// Sends an FCM push to the admin's registered devices (the Android app and/or
// web browsers) when a visitor submits the contact form.
//
// Flow: the public contact form writes the lead to Firestore, then calls this
// function with ONLY the submission ID. We re-read the lead from Firestore and
// build the notification from that, so a caller can't push arbitrary text.
// Guards against abuse of a public endpoint:
//   - the submission must exist and be < MAX_AGE_MS old
//   - it is atomically "claimed" (pushSentAt) so retries/replays send nothing
//
// Per-platform message (the token doc's `platform` field; missing => web):
//   android  `notification` payload, shown by the system even when the app is
//            closed, on the high-importance "new_leads" channel created by
//            MainActivity.
//   web      data-only; web/firebase-messaging-sw.js renders it.
//
// Secrets (set with `supabase secrets set`, never committed):
//   FIREBASE_SERVICE_ACCOUNT  full JSON of a Firebase service-account key
// Optional:
//   ALLOWED_ORIGINS           comma-separated CORS allow-list
//
// Deploy: see supabase/functions/notify-new-lead/README.md

import { importPKCS8, SignJWT } from "npm:jose@5";

const MAX_AGE_MS = 10 * 60 * 1000;
const MAX_TOKENS = 100;
const ID_PATTERN = /^[A-Za-z0-9_-]{1,64}$/;

const ALLOWED_ORIGINS = (Deno.env.get("ALLOWED_ORIGINS") ??
  "https://www.gokulks.in,https://gokulks.in,https://gokul-portfolio-dbdda.web.app,https://gokul-portfolio-dbdda.firebaseapp.com,http://localhost:8765")
  .split(",").map((o) => o.trim()).filter(Boolean);

function corsHeaders(req: Request): HeadersInit {
  const origin = req.headers.get("origin") ?? "";
  return {
    ...(ALLOWED_ORIGINS.includes(origin) ? { "Access-Control-Allow-Origin": origin } : {}),
    "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Vary": "Origin",
  };
}

function json(req: Request, body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders(req), "Content-Type": "application/json" },
  });
}

type ServiceAccount = { project_id: string; client_email: string; private_key: string };

function loadServiceAccount(): ServiceAccount | null {
  try {
    const sa = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT") ?? "");
    return sa.project_id && sa.client_email && sa.private_key ? sa : null;
  } catch {
    return null;
  }
}

async function getAccessToken(sa: ServiceAccount): Promise<string> {
  const key = await importPKCS8(sa.private_key, "RS256");
  const now = Math.floor(Date.now() / 1000);
  const assertion = await new SignJWT({
    scope: "https://www.googleapis.com/auth/firebase.messaging https://www.googleapis.com/auth/datastore",
  })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .setIssuer(sa.client_email)
    .setSubject(sa.client_email)
    .setAudience("https://oauth2.googleapis.com/token")
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(key);

  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion,
    }),
  });
  if (!res.ok) throw new Error(`token exchange failed: ${res.status}`);
  return (await res.json()).access_token;
}

// deno-lint-ignore no-explicit-any
type FsDoc = { name: string; updateTime: string; fields?: Record<string, any> };

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: corsHeaders(req) });
  if (req.method !== "POST") return json(req, { error: "method not allowed" }, 405);

  let submissionId: unknown;
  try {
    submissionId = (await req.json()).submissionId;
  } catch {
    return json(req, { error: "invalid json" }, 400);
  }
  if (typeof submissionId !== "string" || !ID_PATTERN.test(submissionId)) {
    return json(req, { error: "invalid submissionId" }, 400);
  }

  const sa = loadServiceAccount();
  if (!sa) return json(req, { error: "FIREBASE_SERVICE_ACCOUNT is not configured" }, 500);

  const accessToken = await getAccessToken(sa);
  const auth = { Authorization: `Bearer ${accessToken}` };
  const fs = `https://firestore.googleapis.com/v1/projects/${sa.project_id}/databases/(default)/documents`;

  // 1. Load the lead from Firestore — the source of truth for the notification.
  const leadRes = await fetch(`${fs}/submissions/${submissionId}`, { headers: auth });
  if (leadRes.status === 404) return json(req, { skipped: "unknown submission" });
  if (!leadRes.ok) return json(req, { error: `firestore read failed: ${leadRes.status}` }, 502);
  const lead: FsDoc = await leadRes.json();
  const f = lead.fields ?? {};

  const createdAt = Date.parse(f.createdAt?.timestampValue ?? "");
  if (!Number.isFinite(createdAt) || Date.now() - createdAt > MAX_AGE_MS) {
    return json(req, { skipped: "submission too old" });
  }
  if (f.pushSentAt) return json(req, { skipped: "already notified" });

  // 2. Claim it. The updateTime precondition makes this atomic: if two calls
  //    race, exactly one PATCH succeeds and the other gets 409/412.
  const claim = await fetch(
    `${fs}/submissions/${submissionId}?updateMask.fieldPaths=pushSentAt&currentDocument.updateTime=${encodeURIComponent(lead.updateTime)}`,
    {
      method: "PATCH",
      headers: { ...auth, "Content-Type": "application/json" },
      body: JSON.stringify({ fields: { pushSentAt: { timestampValue: new Date().toISOString() } } }),
    },
  );
  if (!claim.ok) return json(req, { skipped: "already notified" });

  // 3. Every registered admin device.
  const tokensRes = await fetch(`${fs}/admin_push_tokens?pageSize=${MAX_TOKENS}`, { headers: auth });
  if (!tokensRes.ok) return json(req, { error: `token list failed: ${tokensRes.status}` }, 502);
  const tokenDocs: FsDoc[] = (await tokensRes.json()).documents ?? [];
  const tokens = tokenDocs.map((d) => ({
    token: decodeURIComponent(d.name.split("/").pop()!),
    platform: String(d.fields?.platform?.stringValue ?? "web"),
  }));
  if (tokens.length === 0) return json(req, { sent: 0, note: "no registered devices" });

  const name = String(f.name?.stringValue ?? "Someone").slice(0, 60);
  const message = String(f.message?.stringValue ?? "").replace(/\s+/g, " ").trim();
  const data = {
    title: `New enquiry from ${name}`,
    body: message.length > 120 ? `${message.slice(0, 117)}…` : message,
    url: "/#/admin",
    submissionId,
  };

  // 4. Send, and prune tokens FCM says are dead so they don't pile up.
  let sent = 0;
  let failed = 0;
  let removed = 0;
  await Promise.all(tokens.map(async ({ token, platform }) => {
    const res = await fetch(`https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`, {
      method: "POST",
      headers: { ...auth, "Content-Type": "application/json" },
      body: JSON.stringify({
        message: platform === "android"
          ? {
            token,
            notification: { title: data.title, body: data.body },
            data: { url: data.url, submissionId },
            android: {
              priority: "HIGH",
              notification: { channel_id: "new_leads", tag: submissionId },
            },
          }
          : { token, data, webpush: { headers: { Urgency: "high", TTL: "86400" } } },
      }),
    });
    if (res.ok) {
      sent++;
      return;
    }
    failed++;
    const detail = await res.text();
    if (res.status === 404 || detail.includes("UNREGISTERED")) {
      const del = await fetch(`${fs}/admin_push_tokens/${encodeURIComponent(token)}`, {
        method: "DELETE",
        headers: auth,
      });
      if (del.ok) removed++;
    }
  }));

  return json(req, { sent, failed, removed });
});
