# Admin Content CMS — Day-by-Day Execution Log

## Purpose

This file is the persistent memory for one specific workstream: making **every piece of
portfolio content** editable, deletable, and hideable from the admin workspace. If a session
loses context, read this file top to bottom before doing anything else — it tells you what's
done, what's next, and the exact patterns to follow so new work stays consistent with what's
already built.

**Rule for every session working from this file:** when you finish a day's checklist items,
check them off (`[x]`) and add a one-line note of what actually happened under that day. If the
plan changed mid-day (a field got dropped, a section needed a different approach), update the
plan text itself, don't just leave it stale. This doc should always reflect reality, not the
original guess.

## Why this exists / background

An earlier audit of the site found that most "content list" sections (achievements,
testimonials, FAQ, skills, education, experience, freelance process, dev-areas marquee, resume
highlights, blog) were either fully hardcoded in Dart widgets or had an admin panel that *looked*
functional (forms, save buttons, success toasts) but only mutated local `setState` — nothing
persisted, nothing reached the public site. The goal of this workstream is to close every one of
those gaps.

---

## Architecture patterns established (read before writing new code)

These were decided in Days 1–2 and every subsequent day should follow them exactly — don't
reinvent a different pattern for a new section.

### Data model convention
Every content-list model (in
[`lib/features/portfolio/models/site_content_models.dart`](../lib/features/portfolio/models/site_content_models.dart))
has: `id`, `displayOrder` (int), `isVisible` (bool), plus its own fields, and:
`fromFirestore(DocumentSnapshot)`, `toFirestore()`, `copyWith(...)`, and a static
`defaults()` seeded from **the real current hardcoded content** (never invented placeholder
copy — always extract the actual live text first).

### Firestore read/write layer
[`lib/core/services/firestore_list_repository.dart`](../lib/core/services/firestore_list_repository.dart)
is a generic `FirestoreListRepository<T>` (`stream()`, `save(id, item)`, `delete(id)`,
`seedIfEmpty(...)`). [`FirebasePortfolioService`](../lib/core/services/firebase_portfolio_service.dart)
wraps one repository per collection behind named methods (`streamFaq()`, `saveFaqItem()`,
`deleteFaqItem()`, ...). New collection → add a `_xRepo` getter + 3 wrapper methods there, plus a
seed block in `ensureContentSeedData()`.

### Public-site state
[`lib/core/providers/portfolio_provider.dart`](../lib/core/providers/portfolio_provider.dart)'s
`PortfolioState` streams every collection and exposes it two ways: the raw list (e.g. `faqItems`,
used by admin so hidden items are still visible for editing) and a `visibleX` getter filtered to
`isVisible` (used by the public widgets). Falls back to `X.defaults()` when Firestore is empty —
never shows a blank section.

### Admin write layer
[`lib/core/providers/admin_portal_provider.dart`](../lib/core/providers/admin_portal_provider.dart)
has thin `saveX`/`deleteX` methods (try/catch → `_handleError`/`_clearError`, same as every
existing method in that file). These collections do **not** get a duplicate `liveX` mirror field
in `AdminPortalState` — admin widgets read straight off `portfolioProvider` via
`ref.watch(portfolioProvider.select((s) => s.x))`, same source as the public site. Only the
original collections (sections, pages, social links, projects, basic details) use the older
`liveX`-mirror pattern; don't extend that pattern to new collections.

### Admin UI
[`lib/features/admin/shared/content_list_workspace.dart`](../lib/features/admin/shared/content_list_workspace.dart)
is a generic list editor (add/edit/delete/hide) that takes `liveItems` + `onSave`/`onDelete`
callbacks. **Use it whenever a section's real shape fits 2–3 flat text fields.** Reference
implementations:
- [`faq_workspace.dart`](../lib/features/admin/modules/faq/faq_workspace.dart) — the template. Question/answer mapped 1:1, zero compromise.
- [`stats_workspace.dart`](../lib/features/admin/modules/home_content/stats_workspace.dart) — same pattern, 3 fields (value/label/placement).

**When a section's real shape doesn't fit flat fields** (nested items, color/icon pickers —
e.g. Achievements has icon+3 colors, Freelance Process has nested sub-bullet items,
Testimonials has a rating+avatar) — don't force it into `ContentListWorkspace`. Build a small
bespoke form for that section instead. Decide the simplification up front (e.g. "icon rotates by
position instead of being admin-picked") and write it down in that day's notes below so it's not
re-litigated later.

### Firestore security rules
[`firestore.rules`](../firestore.rules) — every new collection needs an explicit
`match /collection/{docId} { allow read: if true; allow write: if request.auth != null; }` block
or every read/write silently fails with `permission-denied`. **Deploying rules touches the live
production project (`gokul-portfolio-dbdda`) — always ask the user before running
`firebase deploy --only firestore:rules`.**

### Verification
`.claude/launch.json` runs `flutter run -d chrome --web-port 8765` — use the Browser pane
(`preview_start` with name `flutter_web`) to visually confirm each day's public-site change
actually renders, not just `flutter analyze` clean. Note: the browser tool's `scroll` action has
been unreliable in this environment (times out with "pane hidden") — `resize_window` to a tall
viewport (e.g. 1600x2400) and screenshot instead of scrolling when that happens.

---

## Day-by-day plan

### Day 1 — Data model & schema design ✅ DONE
- [x] Design Firestore-backed models for every hardcoded section → `site_content_models.dart`: `HomeHeroContent`, `SkillItem`, `EducationItem`, `ExperienceStrengthItem`, `AchievementItem`, `ProcessStepItem`/`ProcessStepDetail`, `TestimonialItem`, `FaqItem`, `DevAreaItem`, `StatItem`, `ResumeHighlightGroup`, `BlogPostRecord`
- [x] Extend `BasicDetails` (`content_models.dart`) with `bio` + `location` fields
- [x] Extend `Experience` (`portfolio_models.dart`) with `id`/`displayOrder`/`isVisible` + Firestore serialization
- [x] Add working Location + Bio fields to `basic_details_workspace.dart` (already Firestore-wired, so these worked immediately)

**Note:** `bio` and `location` were deliberately put on `BasicDetails`, not a separate doc — bio
is used across multiple pages (hero, about, contact), same as name/title already were.

### Day 2 — Generic CRUD infrastructure ✅ DONE
- [x] `FirestoreListRepository<T>` generic repo
- [x] `FirebasePortfolioService`: stream/save/delete for all 12 collections + `home_hero` singleton + `ensureContentSeedData()`
- [x] `PortfolioState`: streams + `visibleX` getters for all 12 collections, defaults fallback
- [x] `AdminPortalNotifier`: save/delete methods for all 12 collections
- [x] `ContentListWorkspace`: upgraded from local-state facade to accept live Firestore data + save/delete callbacks
- [x] **Unplanned but required:** `firestore.rules` had no rules at all for the 12 new collections → added them, deployed to production with user's explicit go-ahead
- [x] FAQ wired fully end-to-end as the reference implementation (admin CRUD → Firestore → public `faq_section.dart`)
- [x] Added `.claude/launch.json` for browser preview verification

### Day 3 — Home page: Hero copy + Stats marquee ✅ DONE
- [x] Hero tagline + CTA button label wired to `HomeHeroContent` (`hero_section.dart`)
- [x] `home_content_workspace.dart` rebuilt as a real editor (tagline, CTA label, availability) — removed duplicate name/title/bio fields since those live in Basic Details now
- [x] Fixed a real bug: `_applyBasicDetails` accepted `bio`/`location` but never copied them onto `personalInfo` — now fixed
- [x] Dropped `ctaSecondaryLabel` from the model — no second button exists anywhere in the actual hero design, would've been a dead config field
- [x] Stats marquee (`stats_marquee.dart`, both top + bottom instances on `home_page.dart`) wired to live `StatItem`s with a `placement` field (top/bottom/both)
- [x] New "Stats Marquee" admin module (`stats_workspace.dart`) — added `AdminModule.homeStats` enum value + nav entry + registry wiring
- [x] Verified live in browser: hero copy, CTA, both stat strips all render from Firestore, zero console errors

### Day 4 — Home page: Skills section + Development Areas marquee ✅ DONE
- [x] Skills section (`skills_section.dart`) → wired to `visibleSkills`, reused on Home/About/Skills pages (one fix, three pages)
- [x] Icon rendering: moved the `iconKey → IconData` map out to shared `lib/core/utils/skill_icons.dart` (`iconForSkillKey`, `kSkillIconKeys`) so the public widget and admin icon-picker use the exact same mapping
- [x] Fixed a structural bug while wiring this: the desktop layout hardcoded a 3-left/3-right card split (`List.generate(3, ...)`) which assumed exactly 6 skills forever. Replaced with a dynamic split based on actual list length so admin add/delete doesn't break the layout. Also made the animation-controller pool resize itself when the skill count changes instead of being fixed at `initState`.
- [x] Skills admin panel (`skills_workspace.dart`) rebuilt as a real Firestore-backed editor — bespoke form (not `ContentListWorkspace`, since it needed a proficiency slider + icon picker), including hide/show toggle. Retired the old parallel `SkillEntry` model/`skill_entry.dart` in favor of using the real `SkillItem` model directly — there's only one skills model now, not two.
- [x] Development Areas marquee (`project_types_marquee.dart`) → wired to `visibleDevAreas`
- [x] Development Areas admin panel: new `dev_areas_workspace.dart` using `ContentListWorkspace`. This needed a small infra change: `ContentListWorkspace.fieldTwoLabel`/`fieldTwoHint` are now optional (single-field mode), since `DevAreaItem` only has `label` — no description field to force.
- [x] Verified live in browser: hero/stats/dev-areas all correct with real data; About page confirmed real Education/Experience/Skills content rendering (skill card showing live `80%` proficiency)

**Note:** the homepage's `SkillsSection(scrollController: ...)` instance only animates cards into view once real scroll events fire (pre-existing behavior, not something today's change touched — confirmed identical blank-until-scrolled behavior already existed in the Day 3 screenshots). The About/Skills-page instances (no scrollController) show cards immediately. Not a bug, just noting it so a future session doesn't mistake it for one.

**Tooling note:** hit a scary-looking fully-black page during verification. Root cause was a stale browser tab/DWDS debug connection after several forced reloads in the same tab — not a code issue. Fix: open a fresh tab (`tabs_create`) rather than repeatedly force-navigating the same one when the preview looks stuck.

### Day 5 — Home page: Achievements + Freelance Process + Testimonials + FAQ hide/reorder polish ✅ DONE
- [x] Achievements (`proud_achievements_section.dart`) → wired to `visibleAchievements`. Icon/colors are NOT admin-editable per-item (decided Day 1, confirmed here) — `_achievementCards()` rotates a fixed 3-style set (icon painter + bg/text/number colors, same 3 looks as the old hardcoded cards) by list position, `iconKey` field is stored but unused by rendering
- [x] Achievements admin panel: new `achievements_workspace.dart` — used `ContentListWorkspace`'s 2-field mode (Number/Description) instead of a fully bespoke form, since the real shape (number + description) fits flat fields fine once the field labels match; didn't reuse the old registry entry's mismatched "Headline/Detail/Metric" labels
- [x] Freelance Process (`freelance_process_section.dart`) → wired to `visibleProcessSteps`, converted to `ConsumerWidget`. New bespoke `freelance_process_workspace.dart` (label/number/title/timeEstimate fields + one multiline field for sub-items). **Decision:** sub-items are one line per bullet formatted `"Key: description"` (matches how the key already renders as a bold prefix on the public card); a line with no colon becomes a bullet with an empty key. Parsing/joining helpers are `_parseItems`/`_itemsToText` in that file.
- [x] Testimonials (`testimonials_section.dart`) → wired to `visibleTestimonials`, converted to `ConsumerStatefulWidget`. New bespoke `testimonials_workspace.dart` with a 1–5 rating slider (default 5.0) and an optional avatar URL field. Empty `avatarUrl` now skips `Image.network` entirely (renders initials directly) instead of relying on `errorBuilder` to catch an invalid empty-string URL.
- [x] Verified with `flutter analyze lib` — no issues. Live browser verification pending (see note below).

**Note:** all three collections' Firestore plumbing (models, repo, service streams, `PortfolioState` visible-getters, `AdminPortalNotifier` save/delete methods) already existed from Days 1–2 — this day was purely: (a) swap each public widget's hardcoded list for the provider's `visibleX` getter, (b) build the admin editor. No new infra needed.

### Day 6 — About page: Education + Experience timeline ✅ DONE
- [x] Education entries (`education_experience_section.dart`) → wired to `visibleEducation`. New admin module: `AdminModule.education` + nav entry ("Education", between Skills & Experience and Development Areas) + `education_workspace.dart` — fits `ContentListWorkspace`'s 3-field mode (Title/Description/Period), same pattern as FAQ/DevAreas.
- [x] Experience timeline (same file, `ExperiencePanel`) → wired to `state.visibleExperiences`. **Decision:** did not add a new nav entry for Experience — the existing `AdminModule.skillsExperience` nav item was already titled "Skills & Experience" with a description promising "experience timeline entries" (written before Skills was actually wired on Day 4), so `skills_workspace.dart` now renders two stacked sections in one workspace: the existing Skills editor, and a new bespoke Experience Timeline editor (company/position/duration/description/technologies, technologies entered as a comma-separated field and parsed to `List<String>`).
- [x] Confirmed the `experience` collection is the same one Days 1–2 already wired — no schema change, just consumers switching from `state.experiences.toList()` (unfiltered) to `state.visibleExperiences` (hide-aware). Experience/Resume pages (Days 7/10) will consume the same admin surface built here.
- [x] Verified with `flutter analyze lib` — no issues. Live browser verification: About page renders Education + Experience panels correctly from the provider, zero console errors.

### Day 7 — Experience page: Timeline (reuse) + Strengths ✅ DONE
- [x] Timeline: the Day 6 `experience` collection was already flowing through, but [experience_page.dart](../lib/features/portfolio/pages/experience_page.dart) was passing the unfiltered `state.experiences` into `ExperienceTimelineSection` — hiding an experience in admin wouldn't have hidden it here. One-line fix to `state.visibleExperiences`.
- [x] Strengths section (`experience_strengths_section.dart`) → wired to `visibleExperienceStrengths`, converted to `ConsumerWidget`. New admin module: `AdminModule.experienceStrengths` + nav entry ("Experience Strengths") + `experience_strengths_workspace.dart` — flat title/description fits `ContentListWorkspace`'s 2-field mode exactly (same as FAQ).
- [x] Verified with `flutter analyze lib` — no issues. Live in browser at `/experience`: timeline shows both experience entries, strengths section shows all 4 cards from Firestore, zero console errors.

**Tooling note:** the dev server ignores direct path navigation (`/experience`) and falls back to the home route — this app uses hash-based routing (`/#/experience`) since no `PathUrlStrategy` is configured in `main.dart`. Use the hash form when deep-linking during verification instead of clicking through the UI.

### Day 8 — Skills page (reuse) + Projects page spot-check ✅ DONE
- [x] Skills page (`skills_page.dart`) → confirmed: it renders the same `SkillsSection` widget used on Home/About (`widgets/home/skills_section.dart`), which was wired to `visibleSkills` on Day 4. Zero rework needed — pure verification, checked via `grep` for `visibleSkills` in that widget.
- [x] Projects page spot-check — **found and fixed a real gap.** `adminPortalProvider.liveAppProjects` and the public `portfolioProvider.appProjects` were two disconnected copies of the same Supabase table: the public site only called `_loadAppProjects()` once at app startup (`Future.microtask` in `PortfolioNotifier.build()`), so an admin save/delete/feature-toggle/publish-toggle updated Supabase and the admin's own list, but the homepage featured section and the full Projects page (`state.featuredAppProjects` / `state.publishedAppProjects`) would stay stale until a hard reload — same-session edits never showed up live.
  - Added `PortfolioNotifier.refreshAppProjects()` (public method wrapping the existing private `_loadAppProjects`).
  - `AdminPortalNotifier.saveAppProject()` and `.deleteAppProject()` now call it after a successful Supabase write — covers all four flows since `toggleAppProjectFeatured`/`toggleAppProjectPublished` both route through `saveAppProject`.
  - Confirmed both public consumers already read the correct filtered getters (`featuredAppProjects` = published + featured; `publishedAppProjects` = published only) — no widget-level changes needed, just the missing state-sync link.
- [x] Verified with `flutter analyze lib` — no issues. Live in browser: home "Featured Projects" and `/my-work` "All Projects" both render their correct empty state ("No projects in this category yet.") cleanly with zero console errors — Supabase `projects` table is currently empty so the actual live-update path (add a project in admin → see it appear without reload) could not be click-tested end-to-end, since `/admin` requires the site owner's real Google sign-in, which is not something I can complete. The fix is verified by code trace: both `saveAppProject` and `deleteAppProject` now call the same `refreshAppProjects()` that feeds the exact getters both public pages read.

### Day 9 — Blog page ✅ DONE (needs one manual Supabase step — see below)

**Decision (changed from the original plan):** the original plan assumed Firestore
(`BlogPostRecord`). The user redirected this at the start of the day: blog posts move to
**Supabase** instead, because posts need cover images and Firebase has no Storage on the Spark
plan — Supabase already handles every other upload (project banners/icons, resume, media
library), so this follows the exact same pattern as `AppProject`. Dev.to stays as a
supplementary feed, admin-toggleable (user's explicit choice on the follow-up question).

- [x] `BlogPostRecord` (Firestore, Days 1–2 scaffolding, never had a real UI) — **removed**
  rather than left as a second, unused blog-storage path. Replaced by `AdminBlogPost`
  (`lib/features/admin/modules/blog/models/admin_blog_post.dart`), persisted via
  `SupabaseBlogService` (`blog_posts` table, mirrors `SupabaseProjectsService`/`app_projects`
  exactly — insert/update/delete by id, ordered by `created_at`).
- [x] New tiny Firestore singleton `BlogSettings` (`site_sections/blog_settings`, one field:
  `showDevToFeed`) — kept in Firestore since it's a site-wide toggle, not per-post content, same
  pattern as the existing `home_hero` singleton. No `firestore.rules` change needed —
  `site_sections/{docId}` already matches it.
- [x] `PortfolioState.combinedBlogPosts` — merges published `AdminBlogPost`s (converted to the
  existing `BlogPost` shape) with Dev.to's `blogPosts` (only when `showDevToFeed` is on), sorted
  newest first. This is the one getter `blog_page.dart`/`blog_hero_section.dart`/
  `blog_profile_card.dart` now read — none of the blog *widget* files needed to change beyond
  swapping which getter they call, since the merge happens at the state layer.
- [x] **Day 8 lesson applied up front:** `AdminPortalNotifier.saveBlogPost`/`.deleteBlogPost` call
  `portfolioProvider.notifier.refreshAdminBlogPosts()` after every successful Supabase write, so
  admin edits reach the public blog page within the same session (avoided the exact staleness bug
  found and fixed in Projects on Day 8).
- [x] `blog_workspace.dart` rebuilt as the manage surface — real list from
  `portfolioProvider.adminBlogPosts`, edit dialog with cover-image upload (Supabase Storage,
  `media` bucket, `blog-covers` folder — same bucket Projects/Resume/Media Library already use),
  tags, reading time, featured/published toggles, delete. Also hosts the "Show Dev.to feed"
  switch (blog-specific, so it lives here rather than waiting for the Day 12 Settings pass).
- [x] `create_post_workspace.dart` rewired as the write/compose surface — added a required Title
  field (was missing entirely), auto-generates an excerpt (first 160 chars) and reading time
  (word count ÷ 200 wpm) so the admin doesn't have to fill those in by hand, persists a real
  `AdminBlogPost` on submit. Simplified from a 4-image social-post gallery down to a single cover
  image (a blog post has one cover, not a Twitter-style photo dump) and from a 3-state visibility
  dropdown down to Public/Draft (the third original option, "Portfolio Only", didn't map to any
  real distinct behavior in a single-destination blog). "Save Draft" now actually saves as a
  draft instead of showing a fake success toast.
- [x] Verified with `flutter analyze lib` — no issues (one pre-existing-pattern info lint in
  `blog_workspace.dart` about an interleaved `mounted` check, not a real bug). Live in browser:
  `/blog` renders the featured Dev.to post and post list correctly through `combinedBlogPosts`
  with zero console errors, confirming graceful degradation while the Supabase table doesn't
  exist yet (see below) — `SupabaseBlogService.fetchPosts()` catches and returns `[]`, same
  fallback behavior `AppProjects` already relied on all through Day 8.

**⚠️ Action needed from you before this is fully live:** the `blog_posts` Supabase table doesn't
exist yet — I can't run DDL from here (no service-role access). Run this once in the Supabase SQL
editor (mirrors whatever `app_projects` is already set up with):

```sql
create table if not exists blog_posts (
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

alter table blog_posts enable row level security;

create policy "Public can read blog posts" on blog_posts
  for select using (true);

-- Matches the existing app_projects setup: the admin panel writes via the anon
-- key (no Supabase Auth session — admin access is gated by Firebase Google
-- Sign-In on the client only). Tighten this later if that changes.
create policy "Anon can manage blog posts" on blog_posts
  for all using (true) with check (true);
```

No Storage bucket changes needed — `blog-covers` is just a new folder inside the existing
`media` bucket that `SupabaseStorageService`/Projects/Media Library already upload to.

### Day 10 — Resume page ✅ DONE
- [x] Highlights section (`resume_highlights_section.dart`) → wired to `visibleResumeHighlights`, converted to `ConsumerWidget`. New admin module: `AdminModule.resumeHighlights` + nav entry ("Resume Highlights") + `resume_highlights_workspace.dart` — confirmed the newline-joined-items trick works here exactly as it did for Freelance Process: `ContentListWorkspace`'s flat 2-field mode (title + body), body split/joined on `\n`.
- [x] Experience section on this page (`resume_experience_section.dart`) → **found the same Day-6/Day-7-pattern gap**: it read the unfiltered `state.experiences` instead of `state.visibleExperiences`, so an admin "hide" wouldn't have hidden it here either. One-line fix, same as the Day 7 Experience-page finding — worth checking every remaining consumer of the shared `experience` collection for this exact mistake before assuming "already wired" means "wired correctly."
- [x] Resume Management workspace (file upload/active URL) — confirmed untouched: it only reads/writes `resumeConfig`, a completely separate concern from `resumeHighlights`. No overlap, verified via grep, no changes made.
- [x] Verified with `flutter analyze lib` — no issues. Live in browser: `/resume` renders the Experience Timeline (both roles) and the 3 Highlight cards (Core Skills / Working Style / Value I Bring, all bullets intact) correctly from the provider, zero console errors.

**Tooling note:** this page's sections use `RevealSequence`/`DelayedReveal` — a **timer**-based fade-in (`Timer` in `initState`, not scroll-triggered, unlike `SkillsSection`'s scroll-gated animation from Day 4). A tall `resize_window` + screenshot works fine here, but needs a longer wait (~8–10s total) for every section's staggered `Timer` to fire, not the usual 2–3s — a screenshot taken too early looked like a rendering bug (mostly blank) but was actually just impatience.

### Day 11 — Contact page ⬜ NOT STARTED
- [ ] Location field: already added to Basic Details form (Day 1) and now actually applies (Day 3 bug fix) — verify it displays on the contact page's contact-channels section
- [ ] Contact form → currently posts to Formspree only (`contact_service.dart`), not Firestore. The "Visitor Submissions" admin inbox reads a Firestore `submissions` collection that nothing writes to — it's a dead inbox. Decide: write to Firestore in addition to Formspree, or instead of it? (Firestore rules already allow public `create` on `submissions` — see existing `firestore.rules` block, no rule changes needed here)
- [ ] Social links — already working (Social & Contact workspace, real Firestore) — spot-check only

### Day 12 — Global / cross-cutting ⬜ NOT STARTED
- [ ] "Available for work" toggle — now persists via `HomeHeroContent.isAvailableForWork` (Day 3) and the `AvailableForWorkBadge` widget IS rendered on the hero (confirmed visually Day 3, contradicting an earlier audit claim that it was dead code) — just needs a final check that toggling in admin actually flips the public badge live
- [ ] Settings workspace — decide which toggles (notifications, analytics, maintenance mode) are real features vs. should be removed if there's no backend for them. Don't ship a fake toggle.
- [ ] Media Library — decide: wire it into the image pickers for projects/blog/resume banner uploads (so admin-uploaded media is actually selectable elsewhere), or leave scoped down for now

### Day 13 — QA pass ⬜ NOT STARTED
- [ ] Walk every page top to bottom: for every section, confirm admin edit → live site updates, admin delete → item disappears, admin hide → item disappears from public site but stays in admin list
- [ ] Check ordering/reordering persists and reflects on the public site
- [ ] Cross-page shared data (experience, skills) — confirm editing once updates all consuming pages

### Day 14 — Buffer / polish ⬜ NOT STARTED
- [ ] Fix whatever QA surfaced
- [ ] Polish empty-states in admin lists (zero items should still show a clean "Add" affordance, not a broken layout)

---

## Open decisions log

Running list of things that were deliberately simplified or deferred — check here before
"fixing" something that was actually an intentional trade-off.

- **Icon/color pickers**: ~~Skills and Achievements have no picker UI~~ — **resolved for Skills
  on Day 4**: built a proper icon-swatch picker in `skills_workspace.dart` using the shared
  `kSkillIconKeys` list, cheap enough to justify once `skill_icons.dart` existed. **Resolved for
  Achievements on Day 5**: went the opposite way — `iconKey`/3 hex colors stay in the model (so
  the schema doesn't need to change later) but are not exposed in the admin form at all. The
  public widget rotates a fixed 3-look style set by list position instead, matching the original
  hardcoded 3-card design. Simpler than a 3-color picker UI and the visual rhythm of the row
  matters more than per-card color control.
- **Freelance Process nested items**: **resolved Day 5** — admin edits sub-items as one line per
  bullet in a single multiline field, formatted `"Key: description"`. This mirrors how the key
  already renders as a bold prefix before the description on the public card, so the admin's
  mental model matches the output. See `freelance_process_workspace.dart`.
- **Blog architecture**: **resolved Day 9** — posts live in Supabase (not Firestore) so cover
  images can go through the same Storage flow as project banners; Dev.to stays as a
  user-toggleable supplementary feed. See Day 9 notes above for the full reasoning and the
  Firestore `BlogPostRecord` removal.
- **Contact form → Firestore**: not decided whether to add Firestore writes alongside or instead
  of Formspree. Decide at the start of Day 11.
- **Guiding Principles section**: has a Firestore section key and a `ContentListWorkspace` admin
  panel already, but is not rendered on any public page. Out of scope for this workstream (we're
  only wiring things that are actually live on the site) unless the user asks for it to be added
  to a page.
