-- Blog posts table for the admin Blog Management / Create Post modules and
-- the public /blog page (see lib/features/admin/modules/blog/).
--
-- Run this once in the Supabase Dashboard: Project → SQL Editor → New query
-- → paste this file → Run. Safe to re-run. No storage bucket setup needed —
-- cover images go to the existing `media` bucket (folder `blog-covers/`).

create table if not exists public.blog_posts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  excerpt text not null default '',
  content text not null default '',
  cover_image_url text not null default '',
  tags text[] not null default '{}',
  author_name text not null default '',
  reading_time_minutes integer not null default 5,
  is_published boolean not null default true,
  is_featured boolean not null default false,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

-- Posts published elsewhere (Medium, LinkedIn...): the blog card links out
-- to this URL instead of the in-app reader. Empty for posts written here.
alter table public.blog_posts
  add column if not exists external_url text not null default '';

alter table public.blog_posts enable row level security;

drop policy if exists "Public can read blog posts" on public.blog_posts;
create policy "Public can read blog posts"
  on public.blog_posts for select
  using (true);

-- NOTE ON TRUST MODEL: same as app_projects and testimonials — the admin
-- portal writes with the public anon key (there is no Supabase Auth session;
-- admin access is gated by the app's own /admin sign-in). That makes this
-- policy open to anyone holding the anon key, which ships in the web bundle.
-- Tighten by moving admin writes behind an Edge Function or Supabase Auth.
drop policy if exists "Anon can manage blog posts" on public.blog_posts;
create policy "Anon can manage blog posts"
  on public.blog_posts for all
  using (true)
  with check (true);
