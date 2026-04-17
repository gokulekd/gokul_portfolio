import 'package:cloud_firestore/cloud_firestore.dart';

class SiteSectionKeys {
  const SiteSectionKeys._();

  static const hero = 'hero';
  static const statsTop = 'stats_top';
  static const skillsExperience = 'skills_experience';
  static const featuredProjects = 'featured_projects';
  static const developmentAreas = 'development_areas';
  static const achievements = 'achievements';
  static const guidingPrinciples = 'guiding_principles';
  static const freelanceProcess = 'freelance_process';
  static const testimonials = 'testimonials';
  static const faq = 'faq';
  static const contact = 'contact';
  static const statsBottom = 'stats_bottom';
  static const footer = 'footer';
}

class SiteSectionConfig {
  const SiteSectionConfig({
    required this.id,
    required this.key,
    required this.title,
    required this.description,
    required this.displayOrder,
    required this.isVisible,
    this.updatedAt,
    this.updatedBy,
  });

  final String id;
  final String key;
  final String title;
  final String description;
  final int displayOrder;
  final bool isVisible;
  final DateTime? updatedAt;
  final String? updatedBy;

  factory SiteSectionConfig.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return SiteSectionConfig(
      id: doc.id,
      key: data['key'] as String? ?? doc.id,
      title: data['title'] as String? ?? doc.id,
      description: data['description'] as String? ?? '',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      updatedBy: data['updatedBy'] as String?,
    );
  }

  Map<String, dynamic> toFirestore({String? updatedByValue}) {
    return {
      'key': key,
      'title': title,
      'description': description,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedByValue ?? updatedBy,
    };
  }

  SiteSectionConfig copyWith({
    String? id,
    String? key,
    String? title,
    String? description,
    int? displayOrder,
    bool? isVisible,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return SiteSectionConfig(
      id: id ?? this.id,
      key: key ?? this.key,
      title: title ?? this.title,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  static List<SiteSectionConfig> defaultSections() {
    return const [
      SiteSectionConfig(
        id: SiteSectionKeys.hero,
        key: SiteSectionKeys.hero,
        title: 'Hero Section',
        description: 'Headline, CTA, profile intro, availability state.',
        displayOrder: 1,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.statsTop,
        key: SiteSectionKeys.statsTop,
        title: 'Stats Marquee Top',
        description: 'Top scrolling trust indicators and highlight metrics.',
        displayOrder: 2,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.skillsExperience,
        key: SiteSectionKeys.skillsExperience,
        title: 'Skills & Experience',
        description:
            'Skill percentages, stack labels, and experience timeline.',
        displayOrder: 3,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.featuredProjects,
        key: SiteSectionKeys.featuredProjects,
        title: 'Featured Projects',
        description: 'Homepage portfolio highlights and launch links.',
        displayOrder: 4,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.developmentAreas,
        key: SiteSectionKeys.developmentAreas,
        title: 'Development Areas',
        description: 'Scrolling service and project-type showcase.',
        displayOrder: 5,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.achievements,
        key: SiteSectionKeys.achievements,
        title: 'Proud Achievements',
        description: 'Result-driven metrics and credibility markers.',
        displayOrder: 6,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.guidingPrinciples,
        key: SiteSectionKeys.guidingPrinciples,
        title: 'Guiding Principles',
        description: 'Core principles that shape delivery and collaboration.',
        displayOrder: 7,
        isVisible: false,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.freelanceProcess,
        key: SiteSectionKeys.freelanceProcess,
        title: 'Freelance Process',
        description: 'Client journey from discovery to delivery.',
        displayOrder: 8,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.testimonials,
        key: SiteSectionKeys.testimonials,
        title: 'Testimonials',
        description: 'Client proof and trust-building quotes.',
        displayOrder: 9,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.faq,
        key: SiteSectionKeys.faq,
        title: 'FAQ',
        description: 'Common client questions and answers.',
        displayOrder: 10,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.contact,
        key: SiteSectionKeys.contact,
        title: 'Contact Section',
        description: 'Social contact grid and email CTA.',
        displayOrder: 11,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.statsBottom,
        key: SiteSectionKeys.statsBottom,
        title: 'Stats Marquee Bottom',
        description: 'Closing marquee strip before footer.',
        displayOrder: 12,
        isVisible: true,
      ),
      SiteSectionConfig(
        id: SiteSectionKeys.footer,
        key: SiteSectionKeys.footer,
        title: 'Footer',
        description: 'Final brand and contact footer.',
        displayOrder: 13,
        isVisible: true,
      ),
    ];
  }
}

class ManagedSocialLink {
  const ManagedSocialLink({
    required this.id,
    required this.platform,
    required this.value,
    required this.type,
    required this.displayOrder,
    required this.isVisible,
  });

  final String id;
  final String platform;
  final String value;
  final String type;
  final int displayOrder;
  final bool isVisible;

  factory ManagedSocialLink.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ManagedSocialLink(
      id: doc.id,
      platform: data['platform'] as String? ?? doc.id,
      value: data['value'] as String? ?? '',
      type: data['type'] as String? ?? 'url',
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'platform': platform,
      'value': value,
      'type': type,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static List<ManagedSocialLink> defaultLinks() {
    return const [
      ManagedSocialLink(
        id: 'linkedin',
        platform: 'LinkedIn',
        value: 'https://linkedin.com/in/gokulks',
        type: 'url',
        displayOrder: 1,
        isVisible: true,
      ),
      ManagedSocialLink(
        id: 'twitter',
        platform: 'Twitter',
        value: 'https://twitter.com/gokulks',
        type: 'url',
        displayOrder: 2,
        isVisible: true,
      ),
      ManagedSocialLink(
        id: 'github',
        platform: 'GitHub',
        value: 'https://github.com/gokulks',
        type: 'url',
        displayOrder: 3,
        isVisible: true,
      ),
      ManagedSocialLink(
        id: 'medium',
        platform: 'Medium',
        value: 'https://medium.com/@gokulks',
        type: 'url',
        displayOrder: 4,
        isVisible: true,
      ),
      ManagedSocialLink(
        id: 'instagram',
        platform: 'Instagram',
        value: 'https://instagram.com/gokulks',
        type: 'url',
        displayOrder: 5,
        isVisible: true,
      ),
      ManagedSocialLink(
        id: 'email',
        platform: 'Email',
        value: 'gokulofficialcommunication@gmail.com',
        type: 'email',
        displayOrder: 6,
        isVisible: true,
      ),
    ];
  }
}
