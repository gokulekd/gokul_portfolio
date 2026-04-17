# Admin App Design Structure

## Document Info
- Product: Portfolio Admin Portal
- Project: `gokul_portfolio`
- Type: UX / IA / visual structure document
- Date: 2026-04-18
- Status: Draft v1

## 1. Why This Document Exists
The PRD explains what the admin app must do. The sprint plan explains the build order. This document defines how the admin portal should be structured and designed.

The admin portal should not look like a generic dashboard and it should not copy the public portfolio page layout directly. It should feel like the same brand, but as a premium control center built for editing, reviewing, and publishing.

## 2. Design Direction

### Core Direction
- Premium
- Minimal but powerful
- Editorial + operational
- Sophisticated, not template-like
- Fast to scan, fast to edit

### Relationship to the Website
- Keep the same brand DNA as the portfolio:
  - black and white base
  - green accent language
  - strong typography
  - clean modern spacing
- Do not reuse the public homepage layout inside admin.
- Admin should feel like the backstage system for the same brand.

### Design Principle
The website is the showroom. The admin app is the control room.

## 3. Experience Goals
- Admin should understand site status in 5 seconds
- Admin should reach any content module in 1 click
- Admin should edit content without hunting through long forms
- Admin should see what is live, hidden, draft, or incomplete immediately
- Admin should be able to manage leads and submissions like an inbox

## 4. Information Architecture

### Primary Navigation
- Dashboard
- Site Structure
- Home Content
- Projects
- Skills and Experience
- Development Areas
- Achievements
- Guiding Principles
- Freelance Process
- Testimonials
- FAQ
- Social and Contact
- Blog
- Visitor Submissions
- Media Library
- Settings

### Recommended Grouping

#### Group 1: Control
- Dashboard
- Site Structure
- Settings

#### Group 2: Content
- Home Content
- Projects
- Skills and Experience
- Development Areas
- Achievements
- Guiding Principles
- Freelance Process
- Testimonials
- FAQ
- Social and Contact
- Blog

#### Group 3: Operations
- Visitor Submissions
- Media Library

## 5. Admin App Basic Structure

### Overall Layout
Use a 3-zone layout for desktop:

1. Left rail navigation
2. Main content workspace
3. Context panel / live preview / details panel

This gives the admin a stable operating structure and keeps editing efficient.

### Zone 1: Left Rail
- Brand mark / admin title at top
- Primary navigation modules
- Notification badge for visitor submissions
- User profile and logout at bottom

### Zone 2: Main Workspace
- Page title
- Short module description
- Search / filters / actions row
- Main editable content area

### Zone 3: Context Panel
- Live status
- Save state
- Preview card
- Tips / validation issues
- Record metadata like `updatedAt`, `updatedBy`

## 6. Page Templates

### Template A: Dashboard
Use for:
- overall system overview
- counts
- recent activity
- site health

Sections:
- top welcome band
- key stat cards
- quick actions
- recent submissions list
- recently updated content
- section visibility snapshot

### Template B: Collection Manager
Use for:
- projects
- testimonials
- FAQs
- achievements
- blog posts

Layout:
- list/grid on left or center
- selected item editor on right
- top actions for add, duplicate, archive, filter

### Template C: Structured Editor
Use for:
- hero section
- social links
- contact content
- site-wide text

Layout:
- form-first editor
- sticky save bar
- optional preview drawer

### Template D: Reorderable Section Control
Use for:
- homepage sections
- scrolling content blocks
- featured ordering

Layout:
- reorder list
- visible/hidden toggle
- quick edit
- status chips

### Template E: Submission Inbox
Use for:
- visitor requirement submissions

Layout:
- inbox list column
- detail reading pane
- status/action sidebar

This should feel more like a lead desk than a form table.

## 7. Key Screens

### 7.1 Login Screen
- Full-screen premium login layout
- Brand statement and subtle background motion
- Google sign-in CTA
- Small access note: authorized email only

### 7.2 Dashboard
- Immediate system snapshot
- "What is live" indicators
- "New submissions" priority card
- Quick links to frequently edited modules

### 7.3 Site Structure
- Master list of homepage sections
- Drag to reorder
- Toggle visibility
- View last updated time
- Open section editor directly

### 7.4 Home Content
- Hero content
- homepage headings
- CTA labels
- scrolling strips
- shared homepage copy

### 7.5 Projects Manager
- card or table view
- featured badge
- drag sorting
- quick publish status
- image preview

### 7.6 Skills and Experience Manager
- skill percentage editing
- category grouping
- scrolling display order
- experience timeline editing

### 7.7 Blog Manager
- post list with status chips
- draft / published filters
- editor with preview mode

### 7.8 Visitor Submissions
- unread badge
- priority inbox
- detailed requirement view
- status updates
- notes
- quick contact actions

## 8. Visual Design System

### Brand Base
Use the website’s visual language as reference:
- dark neutrals
- crisp white
- green accent from `AppColors.primaryGreen`

### Recommended Color System
- App background: deep charcoal, not flat black
- Panel background: slightly raised dark surfaces
- Accent: portfolio green
- Success: green variant
- Warning: amber
- Error: muted red
- Neutral text: layered white/gray scale

### Recommended Tone
- High contrast
- Spacious
- Clean edges
- Soft shadows, not heavy glassmorphism
- Selective accent usage

### Typography
- Keep `Manrope` as the primary family for consistency with the existing website
- Use bold, large section titles
- Use compact medium-weight labels
- Use a mono or narrow accent style only for small metadata labels if needed

## 9. Core Components

### Navigation Components
- left rail item
- active module pill
- grouped nav label
- unread notification chip

### Data Components
- stat card
- reorder row
- content card
- visibility switch tile
- inline editable field
- tag chips
- status chips

### Editing Components
- sticky action bar
- split form and preview panel
- autosave or manual save indicator
- destructive action confirmation modal
- image uploader / picker

### Operations Components
- lead inbox row
- lead detail sheet
- activity timeline
- audit metadata block

## 10. Sophistication Requirements
To avoid a generic admin panel, the design should include:

- Strong visual hierarchy with editorial typography
- A branded dashboard header instead of a default app bar
- Structured spacing rhythm
- Section-specific icons and labels
- Live preview panels where useful
- Motion only where it adds meaning
- High-quality empty states
- Clean status system: draft, live, hidden, updated, unread

Do not build a plain CRUD table app and call it done.

## 11. Recommended Interaction Patterns

### Editing Pattern
- Select a module
- Choose an item or section
- Edit in-place in a structured panel
- Save with visible confirmation
- See immediate preview or status update

### Visibility Pattern
- Every public section should show:
  - live
  - hidden
  - incomplete

### Submission Pattern
- New submissions land in inbox
- Unread items float to top
- Admin opens detail
- Admin marks status and writes notes

## 12. Responsive Design

### Desktop
- Full 3-zone layout
- Persistent left rail
- Persistent context panel where useful

### Tablet
- Left rail collapses to icons or drawer
- Context panel becomes slide-over

### Mobile
- Minimum support for urgent edits only
- Dashboard, visibility toggles, and submissions should remain usable
- Heavy content editing can be simplified on smaller screens

## 13. Suggested Module-by-Module Control Map

### Site Structure
- section visibility
- section order
- section titles

### Projects
- featured flag
- display order
- links
- media

### Skills
- skill name
- percentage
- grouping
- order

### Experience
- company
- role
- summary
- technologies
- order

### Development Areas
- label
- icon
- scroll order
- visibility

### Achievements
- title
- metric
- supporting text
- order

### Guiding Principles
- title
- explanation
- icon
- order

### Freelance Process
- step title
- description
- order

### Testimonials
- quote
- client info
- featured/live status

### FAQ
- question
- answer
- order

### Social and Contact
- linkedin
- twitter/x
- github
- medium
- instagram
- email

### Blog
- content
- cover
- tags
- publish status

### Visitor Submissions
- lead details
- notes
- status
- read state

## 14. Recommended Build Sequence for Design
Before implementation starts, the team should lock these four things:

1. Navigation map
2. Dashboard layout
3. Collection editor pattern
4. Submission inbox pattern

These four decisions define the whole admin product.

## 15. Suggested MVP Visual Theme
- Background: charcoal black
- Surface cards: layered graphite panels
- Accent: portfolio green
- Borders: subtle gray strokes
- Radius: medium-large, modern but sharp enough to feel professional
- Motion: subtle fade, slide, and reorder transitions only

## 16. Final Design Rule
The admin portal must feel premium enough that it matches the quality of the portfolio brand, but practical enough that the owner can update content quickly without friction.
