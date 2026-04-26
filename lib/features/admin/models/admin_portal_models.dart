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

enum AdminModuleGroup { control, content, publishing, operations }

extension AdminModuleGroupX on AdminModuleGroup {
  String get label => switch (this) {
    AdminModuleGroup.control => 'Control',
    AdminModuleGroup.content => 'Content',
    AdminModuleGroup.publishing => 'Publishing',
    AdminModuleGroup.operations => 'Operations',
  };
}

enum AdminItemState { live, draft, hidden, warning }

class AdminModuleItem {
  const AdminModuleItem({
    required this.module,
    required this.group,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badgeCount,
  });

  final AdminModule module;
  final AdminModuleGroup group;
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

enum SubmissionStatus { unread, reviewing, inProgress, replied }

class VisitorSubmission {
  const VisitorSubmission({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
    required this.message,
    required this.status,
    required this.createdAt,
    this.notes = const [],
  });

  final String id;
  final String name;
  final String email;
  final String company;
  final String message;
  final SubmissionStatus status;
  final DateTime createdAt;
  final List<String> notes;

  bool get isUnread => status == SubmissionStatus.unread;

  String get statusLabel {
    return switch (status) {
      SubmissionStatus.unread => 'Unread',
      SubmissionStatus.reviewing => 'Reviewing',
      SubmissionStatus.inProgress => 'In Progress',
      SubmissionStatus.replied => 'Replied',
    };
  }

  String get receivedAtFormatted {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hrs ago';
    return '${diff.inDays}d ago';
  }

  factory VisitorSubmission.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    final statusStr = data['status'] as String? ?? 'unread';
    final status = SubmissionStatus.values.firstWhere(
      (s) => s.name == statusStr,
      orElse: () => SubmissionStatus.unread,
    );
    return VisitorSubmission(
      id: id,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      company: data['company'] as String? ?? '',
      message: data['message'] as String? ?? '',
      status: status,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      notes: List<String>.from(data['notes'] as List? ?? const []),
    );
  }

  VisitorSubmission copyWith({SubmissionStatus? status, List<String>? notes}) {
    return VisitorSubmission(
      id: id,
      name: name,
      email: email,
      company: company,
      message: message,
      status: status ?? this.status,
      createdAt: createdAt,
      notes: notes ?? this.notes,
    );
  }
}
