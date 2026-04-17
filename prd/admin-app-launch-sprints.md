# Admin App Launch Plan

## Document Info
- Product: Portfolio Admin App
- Project: `gokul_portfolio`
- Type: Sprint / phase execution plan
- Date: 2026-04-18
- Status: Draft v1

## Objective
Deliver the admin app in a practical order so the portfolio website becomes fully Firebase-driven, admin-manageable, and production-ready with secure login, content management, submission storage, and notifications.

## Delivery Strategy
Build this in controlled phases. The first goal is to lock the admin product design and structure. The second goal is to make the technical foundation stable. The third goal is to migrate content management. The fourth goal is to handle leads and notifications. The final goal is production hardening and launch.

## Sprint 0: UX Structure and Admin Design System

### Goal
Define the admin portal structure before coding so the product does not become a generic dashboard or a collection of disconnected CRUD pages.

### What We Will Do
- Define admin information architecture
- Finalize left navigation structure
- Finalize dashboard layout
- Finalize collection editor pattern
- Finalize section control pattern
- Finalize visitor submission inbox pattern
- Align the admin visual language with the portfolio brand
- Document reusable visual and interaction rules

### Deliverables
- Admin app design structure document
- Screen hierarchy
- Layout pattern decisions
- Visual direction for the portal

### Exit Criteria
- We know exactly how the admin app is structured
- UI implementation can start without redesigning the product mid-build

## Sprint 1: Foundation and Architecture

### Goal
Set up the technical base needed to build the admin app safely and without rework.

### What We Will Do
- Review current Flutter app structure and existing `/admin` route
- Finalize Firebase architecture for auth, Firestore, storage, and notifications
- Create Firebase project configuration for web
- Add Firebase packages to the Flutter project
- Configure Firebase initialization in the app
- Define Firestore collections and content model structure
- Define section keys for all homepage modules
- Decide whether the admin app stays inside the current app or uses a separate admin shell inside the same codebase
- Prepare environment configuration for dev and production

### Deliverables
- Firebase connected to Flutter app
- Initial Firestore schema plan
- Admin module architecture decision
- Shared models for CMS-driven content

### Exit Criteria
- App runs with Firebase initialized
- Collections and document structure are agreed
- Project is ready for auth and CMS implementation

## Sprint 2: Authentication and Admin Access

### Goal
Protect the admin app and allow access only to the owner email through Google login.

### What We Will Do
- Implement Firebase Authentication with Google Sign-In
- Build admin login screen
- Add owner-email allowlist validation
- Build unauthorized access screen
- Persist login session
- Add logout flow
- Protect `/admin` route and nested admin pages
- Add Firestore security rules for admin-only collections

### Deliverables
- Working admin login
- Owner-only access control
- Protected admin route
- Initial security rules

### Exit Criteria
- Only approved email can enter admin area
- Unauthorized users cannot read or write admin content

## Sprint 3: Admin Shell and Navigation

### Goal
Create the usable admin interface structure before adding every content module.

### What We Will Do
- Replace or redesign current `/admin` page layout
- Build admin dashboard shell
- Add left navigation / top navigation
- Add dashboard overview cards
- Add reusable CRUD UI patterns
- Add loading, error, empty, and success states
- Add shared form components for text, list, toggle, reorder, and image fields

### Deliverables
- Admin dashboard layout
- Navigation structure
- Reusable admin UI components

### Exit Criteria
- Admin app is navigable
- New modules can be added quickly with shared components

## Sprint 4: Section Controls and Homepage CMS

### Goal
Move homepage rendering control into Firebase.

### What We Will Do
- Create `site_sections` configuration in Firestore
- Add section visibility toggles
- Add section ordering support
- Update homepage to read section config from Firebase
- Add graceful fallbacks if data is missing
- Make headings and section metadata editable

### Sections Covered
- Hero
- Stats marquee
- Skills / experience scrolling section
- Featured or selected projects
- Development area / project types scrolling section
- Proud achievements
- My Guide Principle
- Freelance process
- Testimonials
- FAQ
- Contact
- Footer links if needed

### Deliverables
- Section toggle management from admin
- Firebase-driven homepage rendering

### Exit Criteria
- Admin can hide/show sections without code changes
- Homepage reflects Firebase content reliably

## Sprint 5: Content Modules CRUD

### Goal
Implement full content management for the main editable modules.

### What We Will Do
- Build featured projects CRUD
- Build skills CRUD with percentage fields
- Build experience CRUD
- Build development area scrolling content CRUD
- Build proud achievements CRUD
- Build My Guide Principle CRUD
- Build freelance process CRUD
- Build testimonials CRUD
- Build FAQ CRUD
- Build social links and contact config CRUD

### Deliverables
- Working forms and list views for all major homepage content types
- Reorder and visibility support where needed

### Exit Criteria
- All requested homepage content can be managed from admin
- Public site reads this content from Firebase

## Sprint 6: Blog Management

### Goal
Enable blog section management from the admin app.

### What We Will Do
- Create blog post data model
- Build blog list and editor screens
- Support draft and published states
- Add tags, slug, excerpt, content, author, and publish date fields
- Update public blog page to read published posts from Firebase

### Deliverables
- Blog CMS
- Firebase-backed public blog feed

### Exit Criteria
- Admin can create, edit, and publish blog posts
- Blog section is no longer code-managed

## Sprint 7: Visitor Requirement Submission System

### Goal
Capture leads correctly and make them visible to the admin.

### What We Will Do
- Design visitor requirement submission schema
- Update public contact or inquiry form
- Save submissions to Firestore
- Validate required fields
- Add submission list screen in admin
- Add filter by status
- Add submission detail view
- Add read/unread and progress status updates
- Add internal notes field

### Deliverables
- Working database-backed lead capture
- Admin submission management screens

### Exit Criteria
- Every visitor requirement is stored in Firebase
- Admin can review and update all submissions

## Sprint 8: Notifications and Realtime Alerts

### Goal
Notify the admin immediately when a new requirement is submitted.

### What We Will Do
- Configure Firebase Cloud Messaging
- Register admin device/browser notification token
- Create Cloud Function trigger on new submission
- Send push notification for each new lead
- Add notification click routing to submission details
- Add fallback realtime in-app alert if push is unavailable

### Deliverables
- Push notification flow
- Realtime alert support

### Exit Criteria
- Admin receives alerts for new submissions
- Notification opens the relevant submission record

## Sprint 9: Media, Validation, and Quality Hardening

### Goal
Reduce admin friction and prepare for production reliability.

### What We Will Do
- Add image upload support via Firebase Storage where needed
- Improve field validation and form UX
- Add confirmation flows for destructive actions
- Improve empty states and data fallback behavior
- Add audit metadata like `updatedAt` and `updatedBy`
- Review responsiveness for desktop and tablet
- Clean up any old hardcoded content dependencies

### Deliverables
- More stable CMS editing experience
- Cleaner production data handling

### Exit Criteria
- Content editing is reliable
- Admin UX is stable enough for live use

## Sprint 10: Testing, Security Review, and Go Live

### Goal
Verify production readiness and launch safely.

### What We Will Do
- Test all admin authentication flows
- Test Firestore rules and unauthorized access cases
- Test section visibility and data rendering on live site
- Test all CRUD modules
- Test blog publishing flow
- Test visitor submission persistence
- Test push notifications on supported environments
- Remove obsolete admin code if no longer needed
- Prepare deployment checklist
- Deploy to production
- Do post-launch verification

### Deliverables
- Production deployment
- Verified live admin app
- Launch checklist completion

### Exit Criteria
- Admin app is live
- Public site reads production Firebase data
- Submission and notification flows work in production

## Recommended Build Order
1. Admin UX structure and design system
2. Firebase setup and architecture
3. Google login and access control
4. Admin shell and dashboard
5. Section visibility system
6. Homepage content CRUD modules
7. Blog CMS
8. Visitor submission database flow
9. Push notifications
10. QA, security, and launch

## Recommended Milestone View

### Milestone 1: Admin Foundation
- Sprint 0
- Sprint 1
- Sprint 2
- Sprint 3

### Milestone 2: Firebase CMS
- Sprint 4
- Sprint 5
- Sprint 6

### Milestone 3: Lead and Notification System
- Sprint 7
- Sprint 8

### Milestone 4: Launch
- Sprint 9
- Sprint 10

## Risks to Watch During Execution
- Web push notification limitations across browsers
- Firestore schema changes mid-project if data structure is not finalized early
- Existing hardcoded widgets may require refactoring before Firebase-driven rendering is clean
- Admin app scope can expand quickly if preview, versioning, and media management are added too early

## Suggested Immediate Next Step
Start with Sprint 0 and Sprint 1 together:

- lock the admin UI structure
- Set up Firebase in the Flutter project
- Configure Google Auth
- Protect the admin route
- Finalize Firestore collections

This gives the design and technical base needed for every later sprint and avoids rebuilding the admin architecture twice.
