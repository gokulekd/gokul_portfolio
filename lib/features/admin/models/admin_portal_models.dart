import 'package:flutter/material.dart';

enum AdminModule {
  dashboard,
  siteStructure,
  homeContent,
  projects,
  skillsExperience,
  developmentAreas,
  achievements,
  guidingPrinciples,
  freelanceProcess,
  testimonials,
  faq,
  socialContact,
  blog,
  submissions,
  mediaLibrary,
  settings,
  createPost,
  managePages,
  resumeManagement,
}

enum AdminItemState { live, draft, hidden, warning }

class AdminModuleItem {
  const AdminModuleItem({
    required this.module,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badgeCount,
  });

  final AdminModule module;
  final String title;
  final String subtitle;
  final IconData icon;
  final int? badgeCount;
}

class AdminMetricItem {
  const AdminMetricItem({
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
}

class AdminSectionItem {
  const AdminSectionItem({
    required this.order,
    required this.title,
    required this.description,
    required this.state,
    required this.isVisible,
    required this.updatedAt,
  });

  final int order;
  final String title;
  final String description;
  final AdminItemState state;
  final bool isVisible;
  final String updatedAt;
}

class AdminCollectionItem {
  const AdminCollectionItem({
    required this.title,
    required this.subtitle,
    required this.state,
    required this.lastEdited,
    this.highlight,
  });

  final String title;
  final String subtitle;
  final AdminItemState state;
  final String lastEdited;
  final String? highlight;
}

class AdminLeadItem {
  const AdminLeadItem({
    required this.name,
    required this.company,
    required this.summary,
    required this.status,
    required this.receivedAt,
    this.unread = false,
  });

  final String name;
  final String company;
  final String summary;
  final String status;
  final String receivedAt;
  final bool unread;
}
