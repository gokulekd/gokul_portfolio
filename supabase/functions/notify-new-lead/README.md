# notify-new-lead

Supabase Edge Function that sends an FCM web-push to the admin's browsers when a
visitor submits the contact form. Lets the project stay on Firebase's free Spark
plan (Cloud Functions would need Blaze).

```
contact form ──► Firestore submissions/{id}
     └────────► this function  {submissionId}
                   ├─ re-reads the lead from Firestore (never trusts caller text)
                   ├─ rejects unknown / >10 min old / already-notified leads
                   ├─ atomically claims it (pushSentAt) so retries send nothing
                   └─ FCM v1 send to every token in Firestore admin_push_tokens
                        (dead tokens are deleted)
```

## One-time setup

1. **VAPID key** — Firebase Console → Project settings → Cloud Messaging →
   Web Push certificates → *Generate key pair*. Put the public key in `.env` as
   `FCM_VAPID_KEY` (see `.env.example`).
2. **Service account** — Firebase Console → Project settings → Service accounts →
   *Generate new private key*. Treat the JSON like a password: don't commit it.
3. **Supabase CLI** — `brew install supabase/tap/supabase`, then `supabase login`.
4. **Secret** (from the folder holding the downloaded key):
   ```bash
   supabase secrets set FIREBASE_SERVICE_ACCOUNT="$(cat service-account.json)" --project-ref <project-ref>
   ```
   `<project-ref>` is the subdomain of your `SUPABASE_URL`.
5. **Deploy the function**:
   ```bash
   supabase functions deploy notify-new-lead --project-ref <project-ref>
   ```
6. **Firestore rules** (adds `admin_push_tokens`): `firebase deploy --only firestore:rules`
7. **Ship the site**: `firebase deploy --only hosting` (builds via `build.sh`, which
   bakes in `FCM_VAPID_KEY`).
8. **Turn it on**: Admin → Settings → Notifications → *Turn on*, allow the
   browser prompt. Each browser/device you want alerts on does this once.

Optional secret `ALLOWED_ORIGINS` (comma-separated) overrides the CORS allow-list
in `index.ts` (defaults to the production domains + `http://localhost:8765`).

## Testing

Close the admin tab (or switch to another tab), submit the contact form from a
different tab/device, and a "New enquiry from …" notification should appear.
Clicking it opens `/#/admin`. Check function logs with
`supabase functions logs notify-new-lead --project-ref <project-ref>`.

## Notes

- The notification is data-only; `web/firebase-messaging-sw.js` renders it.
- With the portal tab focused, the in-app snackbar shows instead of a push.
- Pushes carry the visitor's name and a message snippet to the admin's device.
