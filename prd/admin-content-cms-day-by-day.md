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

### Day 4 — Home page: Skills section + Development Areas marquee ⬜ NOT STARTED
- [ ] Skills section (`skills_section.dart`, home page) → wire to `visibleSkills` (already streamed since Day 2, just needs the widget wired)
- [ ] Decide icon rendering: `SkillItem.iconKey` is a string (`fire`, `code`, `phone_android`, `language`, `palette`, `javascript`, `database`, `cloud`, `terminal`, `layers`, `bolt`, `star`) — build a small `iconKey → IconData` map in the widget layer
- [ ] Skills admin panel: fix "Skills & Experience" workspace (`skills_workspace.dart`) — currently a disconnected local-state facade unrelated to the real skills list. Decide: does it need icon-picker UI, or is a flat `ContentListWorkspace` (name/percent as 2 fields, icon fixed or a 3rd free-text field) good enough?
- [ ] Development Areas marquee (`project_types_marquee.dart`) → wire to `visibleDevAreas`
- [ ] Development Areas admin panel already uses `ContentListWorkspace` in the registry with placeholder data — replace with a live wrapper (same pattern as `faq_workspace.dart`/`stats_workspace.dart`), field mapping: title→label, drop body/meta (real model only has `label`)
- [ ] Verify live in browser

### Day 5 — Home page: Achievements + Freelance Process + Testimonials + FAQ hide/reorder polish ⬜ NOT STARTED
- [ ] Achievements (`proud_achievements_section.dart`) → wire to `visibleAchievements`. Icon/colors are NOT admin-editable per-item (decided Day 1) — render by rotating a fixed icon/color set based on list position instead
- [ ] Achievements admin panel: bespoke form needed (headline/description/number, no color picker) — don't force into `ContentListWorkspace` as-is since registry's current field labels ("Headline"/"Detail"/"Metric") don't match the real public card shape (number + description only)
- [ ] Freelance Process (`freelance_process_section.dart`) → wire to `visibleProcessSteps`. Nested `items` (sub-bullets) don't fit flat fields — decide mapping (e.g. admin edits sub-items as newline-separated text in one field, widget splits on `\n`)
- [ ] Testimonials (`testimonials_section.dart`) → wire to `visibleTestimonials`. `rating` and `avatarUrl` have no admin field yet — default rating to 5.0, handle empty `avatarUrl` gracefully (don't crash `NetworkImage`)
- [ ] Verify live in browser

### Day 6 — About page: Education + Experience timeline ⬜ NOT STARTED
- [ ] Education entries (`education_experience_section.dart`) → wire to `visibleEducation` (currently zero admin surface exists — need a new admin module + nav entry, same as Stats got on Day 3)
- [ ] Experience timeline (same file, `ExperiencePanel`) → wire to `state.visibleExperiences` (the model + Firestore plumbing already exists from Day 1/2, just needs an admin module + the widget needs to stop reading `state.experiences.toList()` directly and use `visibleExperiences`)
- [ ] This `experience` collection is shared across About, Experience page, and Resume page — build it once here, other two days just consume it
- [ ] Verify live in browser

### Day 7 — Experience page: Timeline (reuse) + Strengths ⬜ NOT STARTED
- [ ] Timeline: confirm it already works via the Day 6 `experience` collection — no rework if Day 6 was done right
- [ ] Strengths section (`experience_strengths_section.dart`) → wire to `visibleExperienceStrengths`, new admin module + nav entry
- [ ] Verify live in browser

### Day 8 — Skills page (reuse) + Projects page spot-check ⬜ NOT STARTED
- [ ] Skills page (`skills_page_components.dart` / wherever the skills grid lives on `/my-work` or dedicated skills route) → confirm it reads the same `visibleSkills` from Day 4
- [ ] Projects page: already Supabase-backed and functional — spot-check edit/delete/hide/feature-toggle work end-to-end on both the homepage featured section and the full Projects page; fix any gaps found (this is verification, not new build)

### Day 9 — Blog page ⬜ NOT STARTED — needs a decision first
- [ ] **Decide:** keep Dev.to as the only source, or let admin-authored Firestore posts (`BlogPostRecord`, already modeled Day 1, collection wired Day 2) appear too? Recommendation from the original plan: Firestore posts + Dev.to as an optional supplementary feed with an admin toggle.
- [ ] Wire "Blog" and "Create Post" admin panels to actually write `BlogPostRecord` docs (currently both are local-state-only facades — `blog_workspace.dart`'s `AdminBlogPost` model is a good shape reference, doesn't persist yet; `create_post_workspace.dart` is more of a status-composer UI, may need rethinking)
- [ ] Update `blog_page.dart` to stream Firestore posts, not just call `DevToService.fetchArticles()`
- [ ] Verify live in browser

### Day 10 — Resume page ⬜ NOT STARTED
- [ ] Highlights section (`resume_highlights_section.dart`) → wire to `visibleResumeHighlights`, new admin module + nav entry (note: `ResumeHighlightGroup` has a title + `List<String> items` — this one might fit `ContentListWorkspace` if items are stored as newline-joined text in the body field, same trick as Freelance Process)
- [ ] Experience section on this page → same shared `experience` collection from Day 6, should already work
- [ ] Resume file upload/active URL already works (Resume Management workspace) — don't touch, just verify unaffected
- [ ] Verify live in browser

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

- **Icon/color pickers**: Skills (`iconKey`) and Achievements (`iconKey` + 3 hex colors) are
  modeled with string fields but have no picker UI yet. Current plan (Day 4/5): render by a fixed
  key→visual mapping in the widget, not a free-form admin picker. Revisit only if the user
  explicitly asks for visual customization per item.
- **Freelance Process nested items**: no plan yet for how admin edits the 2–4 sub-bullets per
  step through a flat-field UI. Leaning toward newline-separated text in one field. Decide on
  Day 5, write the actual decision here once made.
- **Blog architecture**: not decided yet whether Firestore posts fully replace or supplement
  Dev.to. Must decide at the start of Day 9 before writing any code that day.
- **Contact form → Firestore**: not decided whether to add Firestore writes alongside or instead
  of Formspree. Decide at the start of Day 11.
- **Guiding Principles section**: has a Firestore section key and a `ContentListWorkspace` admin
  panel already, but is not rendered on any public page. Out of scope for this workstream (we're
  only wiring things that are actually live on the site) unless the user asks for it to be added
  to a page.
