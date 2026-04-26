import 'package:flutter/material.dart';

import '../controllers/admin_portal_controller.dart';
import '../models/admin_portal_models.dart';
import '../shared/content_list_workspace.dart';
import 'blog/blog_workspace.dart';
import 'create_post/create_post_workspace.dart';
import 'dashboard/dashboard_workspace.dart';
import 'home_content/home_content_workspace.dart';
import 'manage_pages/manage_pages_workspace.dart';
import 'media_library/media_library_workspace.dart';
import 'projects/projects_workspace.dart';
import 'resume/resume_workspace.dart';
import 'settings/settings_workspace.dart';
import 'site_structure/site_structure_workspace.dart';
import 'skills/skills_workspace.dart';
import 'social_contact/social_contact_workspace.dart';
import 'submissions/submissions_workspace.dart';

class AdminModuleRegistry {
  const AdminModuleRegistry._();

  static Widget buildWorkspace({
    required AdminModule module,
    required AdminPortalController controller,
    required bool isCompact,
  }) {
    return switch (module) {
      AdminModule.dashboard => DashboardWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.siteStructure => SiteStructureWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.homeContent => HomeContentWorkspace(isCompact: isCompact),
      AdminModule.projects => ProjectsWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.skillsExperience => SkillsWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.developmentAreas => _contentListWorkspace(
        module: module,
        isCompact: isCompact,
        eyebrow: 'DEVELOPMENT AREAS',
        title: 'Specialisations',
        description:
            'Keep the scrolling service and specialisation content aligned with current offerings.',
        itemLabel: 'Area',
        fieldOneLabel: 'Area title',
        fieldOneHint: 'e.g. Flutter Mobile Apps',
        fieldTwoLabel: 'Description',
        fieldTwoHint: 'What you offer in this area…',
        defaultItems: const [
          ContentItem(
            title: 'Flutter Mobile Apps',
            body: 'Production-ready iOS & Android apps with pixel-perfect UI.',
            isVisible: true,
          ),
          ContentItem(
            title: 'Firebase Backends',
            body:
                'Auth, Firestore, Storage, and Cloud Functions for scalable backends.',
            isVisible: true,
          ),
          ContentItem(
            title: 'Admin Dashboards',
            body: 'Custom CMS and admin portals built with Flutter Web.',
            isVisible: true,
          ),
          ContentItem(
            title: 'UI/UX Design',
            body:
                'Design systems, component libraries, and high-fidelity Figma prototypes.',
            isVisible: false,
          ),
        ],
      ),
      AdminModule.achievements => _contentListWorkspace(
        module: module,
        isCompact: isCompact,
        eyebrow: 'ACHIEVEMENTS',
        title: 'Milestones & proof points',
        description:
            'Manage credibility markers, metrics, and milestone cards shown on the portfolio.',
        itemLabel: 'Achievement',
        fieldOneLabel: 'Headline',
        fieldOneHint: 'e.g. 50+ Apps Delivered',
        fieldTwoLabel: 'Detail',
        fieldTwoHint: 'Brief supporting description…',
        fieldThreeLabel: 'Metric / Badge',
        fieldThreeHint: 'e.g. 50+',
        defaultItems: const [
          ContentItem(
            title: '50+ Apps Delivered',
            body:
                'Cross-platform Flutter applications shipped across mobile, web, and desktop.',
            meta: '50+',
            isVisible: true,
          ),
          ContentItem(
            title: '4.9★ Client Rating',
            body:
                'Consistent five-star feedback across freelance platforms and direct clients.',
            meta: '4.9★',
            isVisible: true,
          ),
          ContentItem(
            title: '3 Years Flutter',
            body:
                'Building production Flutter apps since the stable release in 2021.',
            meta: '3yr',
            isVisible: true,
          ),
        ],
      ),
      AdminModule.guidingPrinciples => _contentListWorkspace(
        module: module,
        isCompact: isCompact,
        eyebrow: 'GUIDING PRINCIPLES',
        title: 'Core operating values',
        description:
            'Shape the values and creative principles that sit behind the work.',
        itemLabel: 'Principle',
        fieldOneLabel: 'Principle title',
        fieldOneHint: 'e.g. Ship with intention',
        fieldTwoLabel: 'Description',
        fieldTwoHint: 'What this principle means in practice…',
        defaultItems: const [
          ContentItem(
            title: 'Ship with intention',
            body: 'Every release is deliberate. Quality over velocity, always.',
            isVisible: true,
          ),
          ContentItem(
            title: 'Design from first principles',
            body: 'Start from the user\'s goal, not the component library.',
            isVisible: true,
          ),
          ContentItem(
            title: 'Own the outcome',
            body: 'Take full responsibility for delivery — from brief to live.',
            isVisible: true,
          ),
        ],
      ),
      AdminModule.freelanceProcess => _contentListWorkspace(
        module: module,
        isCompact: isCompact,
        eyebrow: 'FREELANCE PROCESS',
        title: 'Client journey steps',
        description:
            'Define how prospects understand the collaboration flow from first message to delivery.',
        itemLabel: 'Step',
        fieldOneLabel: 'Step title',
        fieldOneHint: 'e.g. Discovery call',
        fieldTwoLabel: 'Description',
        fieldTwoHint: 'What happens in this step…',
        fieldThreeLabel: 'Step number / Badge',
        fieldThreeHint: 'e.g. 01',
        defaultItems: const [
          ContentItem(
            title: 'Discovery call',
            body:
                'We align on goals, scope, timeline, and budget before anything is written.',
            meta: '01',
            isVisible: true,
          ),
          ContentItem(
            title: 'Proposal & scope',
            body:
                'A detailed proposal with milestones, tech decisions, and pricing.',
            meta: '02',
            isVisible: true,
          ),
          ContentItem(
            title: 'Build & iterate',
            body:
                'Weekly check-ins, live previews, and rapid iteration on feedback.',
            meta: '03',
            isVisible: true,
          ),
          ContentItem(
            title: 'Handoff & support',
            body:
                'Full code handoff, documentation, and post-launch support window.',
            meta: '04',
            isVisible: true,
          ),
        ],
      ),
      AdminModule.testimonials => _contentListWorkspace(
        module: module,
        isCompact: isCompact,
        eyebrow: 'TESTIMONIALS',
        title: 'Client feedback',
        description:
            'Manage client quotes and social proof shown on the portfolio.',
        itemLabel: 'Testimonial',
        fieldOneLabel: 'Client name',
        fieldOneHint: 'e.g. Jane Doe, Acme Corp',
        fieldTwoLabel: 'Quote',
        fieldTwoHint: 'What the client said…',
        fieldThreeLabel: 'Role / Company',
        fieldThreeHint: 'e.g. CEO at Acme Corp',
        defaultItems: const [
          ContentItem(
            title: 'Sarah K.',
            body:
                'Gokul delivered a stunning portfolio and admin dashboard on time. Highly recommend.',
            meta: 'Founder, Pixel Studio',
            isVisible: true,
          ),
          ContentItem(
            title: 'Raj M.',
            body:
                'Exceptional Flutter work. The attention to detail in UI and Firebase integration was impressive.',
            meta: 'CTO, MiraHealth',
            isVisible: true,
          ),
        ],
      ),
      AdminModule.faq => _contentListWorkspace(
        module: module,
        isCompact: isCompact,
        eyebrow: 'FAQ',
        title: 'Frequently asked questions',
        description:
            'Manage questions and answers shown on the portfolio contact section.',
        itemLabel: 'FAQ item',
        fieldOneLabel: 'Question',
        fieldOneHint: 'e.g. What is your tech stack?',
        fieldTwoLabel: 'Answer',
        fieldTwoHint: 'Clear, concise answer…',
        defaultItems: const [
          ContentItem(
            title: 'What is your primary tech stack?',
            body:
                'Flutter & Dart for cross-platform apps, Firebase for backend, GetX for state management.',
            isVisible: true,
          ),
          ContentItem(
            title: 'Do you take freelance projects?',
            body:
                'Yes — I take select freelance projects. Reach out via the contact form with your brief.',
            isVisible: true,
          ),
          ContentItem(
            title: 'What is your typical turnaround?',
            body:
                'A standard MVP takes 4–8 weeks depending on scope. Complex apps may take longer.',
            isVisible: false,
          ),
        ],
      ),
      AdminModule.socialContact => SocialContactWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.blog => BlogWorkspace(isCompact: isCompact),
      AdminModule.submissions => SubmissionsWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.mediaLibrary => MediaLibraryWorkspace(isCompact: isCompact),
      AdminModule.settings => SettingsWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.createPost => CreatePostWorkspace(isCompact: isCompact),
      AdminModule.managePages => ManagePagesWorkspace(
        controller: controller,
        isCompact: isCompact,
      ),
      AdminModule.resumeManagement => ResumeManagementWorkspace(
        isCompact: isCompact,
      ),
    };
  }

  static Widget fallbackWorkspace({
    required AdminPortalController controller,
    required bool isCompact,
  }) {
    return FallbackModuleWorkspace(
      controller: controller,
      isCompact: isCompact,
    );
  }

  static ContentListWorkspace _contentListWorkspace({
    required AdminModule module,
    required bool isCompact,
    required String eyebrow,
    required String title,
    required String description,
    required String itemLabel,
    required String fieldOneLabel,
    required String fieldOneHint,
    required String fieldTwoLabel,
    required String fieldTwoHint,
    String? fieldThreeLabel,
    String? fieldThreeHint,
    required List<ContentItem> defaultItems,
  }) {
    return ContentListWorkspace(
      module: module,
      isCompact: isCompact,
      eyebrow: eyebrow,
      title: title,
      description: description,
      itemLabel: itemLabel,
      fieldOneLabel: fieldOneLabel,
      fieldOneHint: fieldOneHint,
      fieldTwoLabel: fieldTwoLabel,
      fieldTwoHint: fieldTwoHint,
      fieldThreeLabel: fieldThreeLabel,
      fieldThreeHint: fieldThreeHint,
      defaultItems: defaultItems,
    );
  }
}
