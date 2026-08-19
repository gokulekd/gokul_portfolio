-- Testimonials table for the public "Leave a review" page (/leave-a-review)
-- and its admin moderation queue (Admin Portal → Testimonials).
--
-- Run this once in the Supabase Dashboard: Project → SQL Editor → New query
-- → paste this file → Run. No storage bucket setup needed — avatar photos
-- reuse the existing `media` bucket (folder `media/testimonials/`) that the
-- rest of the app's uploads already use.

create table if not exists public.testimonials (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  role text not null default '',
  message text not null,
  rating numeric not null default 5,
  avatar_url text not null default '',
  status text not null default 'pending' check (status in ('pending', 'published', 'hidden')),
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists testimonials_status_idx on public.testimonials (status);
create index if not exists testimonials_created_at_idx on public.testimonials (created_at desc);

alter table public.testimonials enable row level security;

-- Visitors submitting the public form can only ever insert as 'pending' —
-- the app already forces this client-side, this is a defence-in-depth check
-- so a submission can never publish itself straight to the live portfolio.
create policy "public can submit testimonials"
  on public.testimonials for insert
  to anon
  with check (status = 'pending');

-- Anyone can read rows — the public site filters to `status = 'published'`
-- client-side, and the admin portal needs to see pending/hidden ones too.
create policy "anyone can read testimonials"
  on public.testimonials for select
  to anon
  using (true);

-- NOTE ON TRUST MODEL: like this project's other Supabase tables
-- (blog_posts, app_projects), the admin portal uses the SAME anon key as the
-- public site — there's no separate service-role key configured
-- (`lib/core/supabase/supabase_bootstrap.dart` only reads SUPABASE_URL /
-- SUPABASE_ANON_KEY). Admin access is gated by the app's own /admin auth
-- wall, not by Postgres RLS. That means these UPDATE/DELETE policies are
-- open to any caller holding the anon key — which is visible in the
-- deployed web bundle. In practice this means someone with dev tools open
-- could, in theory, call the Supabase REST API directly to alter or delete
-- a review. If you want this locked down properly, the fix is to move
-- admin writes behind a Supabase Edge Function (or enable Supabase Auth and
-- scope these policies to an authenticated admin role) rather than relying
-- on RLS `using (true)`.
create policy "anon can update testimonials"
  on public.testimonials for update
  to anon
  using (true)
  with check (true);

create policy "anon can delete testimonials"
  on public.testimonials for delete
  to anon
  using (true);
