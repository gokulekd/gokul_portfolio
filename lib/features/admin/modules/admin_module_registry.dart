import 'package:flutter/material.dart';

import '../models/admin_portal_models.dart';
import '../shared/content_list_workspace.dart';
import 'achievements/achievements_workspace.dart';
import 'basic_details/basic_details_workspace.dart';
import 'blog/blog_workspace.dart';
import 'create_post/create_post_workspace.dart';
import 'dashboard/dashboard_workspace.dart';
import 'dev_areas/dev_areas_workspace.dart';
import 'education/education_workspace.dart';
import 'experience_strengths/experience_strengths_workspace.dart';
import 'faq/faq_workspace.dart';
import 'freelance_process/freelance_process_workspace.dart';
import 'home_content/home_content_workspace.dart';
import 'home_content/stats_workspace.dart';
import 'manage_pages/manage_pages_workspace.dart';
import 'media_library/media_library_workspace.dart';
import 'projects/projects_workspace.dart';
import 'resume/resume_workspace.dart';
import 'resume_highlights/resume_highlights_workspace.dart';
import 'settings/settings_workspace.dart';
import 'site_structure/site_structure_workspace.dart';
import 'skills/skills_workspace.dart';
import 'social_contact/social_contact_workspace.dart';
import 'submissions/submissions_workspace.dart';
import 'testimonials/testimonials_workspace.dart';

class AdminModuleRegistry {
  const AdminModuleRegistry._();

  static Widget buildWorkspace({
    required AdminModule module,
    required bool isCompact,
  }) {
    return switch (module) {
      AdminModule.dashboard => DashboardWorkspace(isCompact: isCompact),
      AdminModule.basicDetails => BasicDetailsWorkspace(isCompact: isCompact),
      AdminModule.siteStructure => SiteStructureWorkspace(isCompact: isCompact),
      AdminModule.homeContent => HomeContentWorkspace(isCompact: isCompact),
      AdminModule.homeStats => StatsWorkspace(isCompact: isCompact),
      AdminModule.projects => ProjectsWorkspace(isCompact: isCompact),
      AdminModule.skillsExperience => SkillsWorkspace(isCompact: isCompact),
      AdminModule.education => EducationWorkspace(isCompact: isCompact),
      AdminModule.experienceStrengths => ExperienceStrengthsWorkspace(isCompact: isCompact),
      AdminModule.resumeHighlights => ResumeHighlightsWorkspace(isCompact: isCompact),
      AdminModule.developmentAreas => DevAreasWorkspace(isCompact: isCompact),
      AdminModule.achievements => AchievementsWorkspace(isCompact: isCompact),
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
      AdminModule.freelanceProcess => FreelanceProcessWorkspace(isCompact: isCompact),
      AdminModule.testimonials => TestimonialsWorkspace(isCompact: isCompact),
      AdminModule.faq => FaqWorkspace(isCompact: isCompact),
      AdminModule.socialContact => SocialContactWorkspace(isCompact: isCompact),
      AdminModule.blog => BlogWorkspace(isCompact: isCompact),
      AdminModule.submissions => SubmissionsWorkspace(isCompact: isCompact),
      AdminModule.mediaLibrary => MediaLibraryWorkspace(isCompact: isCompact),
      AdminModule.settings => SettingsWorkspace(isCompact: isCompact),
      AdminModule.createPost => CreatePostWorkspace(isCompact: isCompact),
      AdminModule.managePages => ManagePagesWorkspace(isCompact: isCompact),
      AdminModule.resumeManagement => ResumeManagementWorkspace(isCompact: isCompact),
    };
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
