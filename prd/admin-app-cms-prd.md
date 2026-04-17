# PRD: Portfolio Website Admin App and Firebase CMS

## Document Info
- Product: Portfolio Website Admin App
- Project: `gokul_portfolio`
- Platform: Flutter web admin app + Firebase backend
- Date: 2026-04-18
- Status: Draft v1

## 1. Product Summary
Build an authenticated admin application for the portfolio website so the site owner can manage all homepage sections, social links, blog entries, skills, featured projects, and visitor submissions from Firebase instead of hardcoded content.

The admin app will replace or expand the current `/admin` page, which is currently focused on social publishing, into a proper CMS for the portfolio website.

## 2. Problem Statement
The current portfolio site is largely code-driven. Content changes require manual code edits and redeployment. This creates operational friction for:

- Showing or hiding homepage sections
- Updating featured projects
- Managing experience, skills, achievements, testimonials, FAQs, and process content
- Updating social links and contact details
- Managing blog content
- Reviewing visitor requirement submissions
- Receiving immediate alerts when a new visitor submits a form

## 3. Goals
- Provide secure admin login using Google Authentication
- Allow only the owner email to access the admin app
- Store editable website content in Firebase
- Control section visibility from Firebase config
- Support CRUD operations for all major homepage content blocks
- Store visitor requirement submissions in the database
- Send push notifications to the admin app for new submissions
- Reduce content updates to no-code or low-code operations

## 4. Non-Goals
- Multi-admin collaboration in phase 1
- Rich text blog editor with advanced formatting in phase 1
- Public-facing blog comments
- Complex role-based permissions beyond owner-only access
- Analytics dashboard beyond basic submission and content counts

## 5. Primary User
- Site owner / admin
  - Logs in with a Google account
  - Uses the admin panel to edit website content
  - Reviews visitor requirements and submission history
  - Receives notifications for new submissions

## 6. Key User Stories
- As the site owner, I want to log in with Google so that only I can manage the website.
- As the site owner, I want to hide or show website sections from the admin panel so I can change the homepage without code changes.
- As the site owner, I want to update featured projects, skills, achievements, process items, testimonials, FAQs, and social links so the site always stays current.
- As the site owner, I want to manage blog content from the admin panel so I can publish and edit posts easily.
- As the site owner, I want every visitor requirement submission saved in Firebase so no lead is lost.
- As the site owner, I want a push notification when a new visitor submits a requirement so I can respond quickly.

## 7. Scope

### In Scope
- Google Sign-In with Firebase Authentication
- Owner email allowlist check
- Admin dashboard
- Section visibility management via Firebase config/document flags
- Content CRUD for homepage modules
- Social/contact link management
- Blog management
- Visitor submission storage and review
- Push notifications for new submissions

### Out of Scope for Phase 1
- Approval workflows
- Content versioning with rollback UI
- Scheduled publishing
- Multi-language localization
- A/B testing

## 8. Current Site Areas to Manage
The current Flutter site already contains or strongly relates to these homepage sections:

- Hero section
- Stats marquee / scrolling strips
- Skills / experience style scrolling content
- Selected or featured projects
- Project types / development areas scrolling view
- Proud achievements
- Freelance process
- Testimonials
- FAQ
- Contact / social links
- Footer

The admin CMS should make these sections data-driven and configurable from Firebase.

## 9. Functional Requirements

### 9.1 Authentication and Access Control
- Use Firebase Authentication with Google Sign-In.
- After login, validate the logged-in email against an allowlist.
- Only the owner email should be granted admin access.
- Unauthorized users should see an access denied state and should not load admin data.
- Admin session should persist across refresh where supported by Firebase Auth.
- Admin logout should be available from the app header.

### 9.2 Admin Dashboard
- Show overview cards:
  - Total visible sections
  - Total featured projects
  - Total blog posts
  - Total visitor submissions
  - Recent unread submissions
- Show quick links to major content modules.
- Show recent submission activity.

### 9.3 Section Controls
- Every homepage section must have a visibility toggle stored in Firebase.
- Section order should be configurable for reorderable sections.
- Each section should support:
  - `isVisible`
  - `title`
  - `subtitle` where applicable
  - content payload specific to the section
- Website should render sections based on Firebase-driven config.

### 9.4 Featured Projects Management
- Add, edit, delete, and reorder projects.
- Mark project as featured.
- Fields:
  - title
  - description
  - image URL or Firebase Storage asset
  - technologies
  - GitHub URL
  - live/demo URL
  - category
  - featured flag
  - display order
  - status

### 9.5 Experience / Skills Scrolling View Management
- Manage experience entries displayed in scrolling or marquee-style sections.
- Manage skills with percentage or proficiency values.
- Fields:
  - skill name
  - percentage / proficiency
  - category
  - icon or image
  - sort order
- Experience fields:
  - company
  - role
  - duration
  - summary
  - technologies
  - sort order

### 9.6 Development App Area Scrolling View Management
- Manage items for the development area / project types scrolling section from Firebase.
- Fields:
  - title
  - short description
  - icon or image
  - badge / label
  - sort order
  - visible flag

### 9.7 Proud Achievements Management
- Add, edit, delete, and reorder achievements.
- Fields:
  - title
  - description
  - value / metric
  - icon
  - year or timeframe
  - sort order

### 9.8 My Guide Principle Management
- Add a Firebase-managed section for "My Guide Principle" or "Guiding Principles".
- Support multiple principle cards or a single grouped section.
- Fields:
  - title
  - description
  - icon
  - order
  - visible flag

### 9.9 Freelance Process Management
- Manage steps in the freelance process section.
- Fields:
  - step title
  - step number
  - description
  - icon
  - sort order

### 9.10 Testimonials Management
- Add, edit, delete, publish/unpublish testimonials.
- Fields:
  - client name
  - role / company
  - testimonial text
  - avatar image
  - rating
  - featured flag
  - sort order

### 9.11 FAQ Management
- Add, edit, delete, reorder FAQ entries.
- Fields:
  - question
  - answer
  - category
  - sort order
  - visible flag

### 9.12 Social Links and Contact Management
- Manage all public social links from the admin panel:
  - LinkedIn
  - Twitter / X
  - GitHub
  - Medium
  - Instagram
  - Email
- Optional support:
  - Facebook if still needed by the existing admin page
- Fields:
  - platform
  - URL or email value
  - visible flag
  - sort order

### 9.13 Blog Management
- Add, edit, delete, publish/unpublish blog entries.
- Fields:
  - title
  - slug
  - excerpt
  - body
  - cover image
  - tags
  - author
  - publish date
  - status: draft / published
- The public blog section should read published posts from Firebase.

### 9.14 General Site Content Management
- Editable site data should include:
  - skill percentages
  - labels and copy text
  - CTA text
  - button links
  - section headings
  - section descriptions
- Admin should be able to update content without touching code.

### 9.15 Visitor Requirement Submission Management
- Public website visitors can submit a requirement or inquiry form.
- Every submission must be saved in Firebase.
- Submission fields:
  - full name
  - email
  - phone number
  - company
  - project type
  - budget range
  - timeline
  - message / requirement details
  - source page
  - created timestamp
  - status: new / in-progress / closed
  - notes
- Admin should be able to:
  - list all submissions
  - filter by status
  - mark as read
  - update status
  - add internal notes

### 9.16 Push Notifications
- When a new visitor submission is created, the admin app should receive a push notification.
- Use Firebase Cloud Messaging for notifications.
- Notification content:
  - title: New visitor requirement
  - body: visitor name + short message preview
- Clicking the notification should open the submission detail in the admin app.
- If web push is not available in the target deployment, fallback to in-app realtime alert plus optional email notification.

## 10. Firebase Architecture

### Recommended Firebase Services
- Firebase Authentication for Google login
- Cloud Firestore for structured content and submissions
- Firebase Storage for images and assets
- Firebase Cloud Messaging for push notifications
- Cloud Functions for:
  - submission-triggered notifications
  - server-side validation
  - optional email allowlist checks

### Suggested Firestore Collections
- `admin_config`
  - owner email allowlist
  - section config
- `site_sections`
  - per-section config and display data
- `projects`
- `skills`
- `experiences`
- `development_areas`
- `achievements`
- `guiding_principles`
- `freelance_process`
- `testimonials`
- `faqs`
- `social_links`
- `blog_posts`
- `visitor_submissions`
- `notification_tokens`

## 11. Suggested Data Model Notes

### Example `site_sections` document fields
- `key`
- `title`
- `subtitle`
- `isVisible`
- `displayOrder`
- `updatedAt`
- `updatedBy`

### Example `visitor_submissions` document fields
- `name`
- `email`
- `phone`
- `company`
- `projectType`
- `budget`
- `timeline`
- `message`
- `status`
- `isRead`
- `notes`
- `createdAt`
- `updatedAt`

## 12. Admin App Screens
- Login screen
- Unauthorized / access denied screen
- Dashboard
- Section controls
- Projects manager
- Skills and experience manager
- Development areas manager
- Achievements manager
- Guiding principles manager
- Freelance process manager
- Testimonials manager
- FAQ manager
- Social links manager
- Blog manager
- Visitor submissions list
- Visitor submission detail view
- Notification settings / token registration status

## 13. UX Requirements
- Clean left navigation for content modules
- Fast edit flows with add, edit, delete, reorder, and preview
- Form validation on all required fields
- Save success and error states
- Unsaved-change warning where relevant
- Mobile-friendly enough for quick edits, but optimized for desktop admin use

## 14. Security Requirements
- Restrict admin routes behind authentication
- Enforce Firestore security rules so only authorized admin email can read/write CMS data
- Prevent public users from reading admin-only collections
- Public users may only write to submission endpoints/collections allowed by rules
- Protect notification token management from public access
- Sanitize and validate user submission fields

## 15. Non-Functional Requirements
- Website should not break if a section has no data; empty states should be handled gracefully
- Homepage content should load with acceptable performance on web
- Content reads should be cached or optimized where appropriate
- Admin save operations should complete within acceptable UI latency
- Real-time updates are preferred for admin views where useful

## 16. Reporting and Audit
- Store `updatedAt` and `updatedBy` on editable records
- Track submission status changes
- Log notification dispatch success/failure in Cloud Functions if implemented

## 17. Dependencies
- Firebase project setup
- Google Sign-In configuration for Flutter web
- Firestore rules
- Firebase Hosting or current hosting integration
- FCM web configuration and service worker setup if using web push

## 18. Delivery Phases

### Phase 1
- Auth
- Owner-only access
- Section visibility control
- Projects, skills, experience, development areas
- Achievements, guiding principles, freelance process
- Testimonials, FAQ, social links
- Visitor submission storage and admin list view
- Basic push notifications

### Phase 2
- Blog editor improvements
- Preview mode
- Draft/publish workflows
- Media library improvements
- Notification preferences

## 19. Acceptance Criteria
- Admin can log in with Google using the owner email.
- Non-owner email cannot access admin content.
- Every homepage section can be shown or hidden from Firebase-driven config.
- Featured projects can be added, edited, deleted, and reordered.
- Skills, percentages, and experience data can be edited from admin and reflect on the live site.
- Development area scrolling content is editable from Firebase.
- Proud achievements can be managed from admin.
- My Guide Principle content is managed from Firebase.
- Freelance process steps can be managed from admin.
- Testimonials and FAQs are editable from Firebase.
- Social links and contact email are editable from admin.
- Blog entries can be created and updated from admin.
- Visitor requirement submissions are saved to the database.
- Admin receives a push notification when a new visitor requirement is submitted.

## 20. Risks and Open Questions
- FCM push notification support on web can vary by browser and permission state.
- Need to confirm whether blog content should be plain text, markdown, or rich text.
- Need to confirm whether "My Guide principal" means a single section or a repeatable list of principles.
- Need to confirm whether the current social publishing admin features should remain in the admin app or move to a separate tool.
- Need to confirm whether images will be pasted as URLs or uploaded to Firebase Storage.

## 21. Recommended Technical Direction
- Keep the public portfolio site and admin app in the same Flutter codebase for speed of delivery.
- Repurpose the existing `/admin` route into a CMS dashboard.
- Move hardcoded content into Firestore-backed repositories and models.
- Use Firebase Remote Config only for lightweight flags if needed, but use Firestore for editable CMS content and section settings because content is richer than simple config.

## 22. Success Metric
The product is successful when the owner can manage homepage content, blog content, social links, and visitor submissions entirely from the admin app without changing source code, while receiving reliable alerts for new leads.
