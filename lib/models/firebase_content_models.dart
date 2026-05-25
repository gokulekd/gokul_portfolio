import 'package:cloud_firestore/cloud_firestore.dart';

// ─── Resume ────────────────────────────────────────────────────────────────

class ResumeVersion {
  const ResumeVersion({
    required this.url,
    required this.fileName,
    required this.sizeBytes,
    required this.uploadedAt,
    required this.supabasePath,
  });

  final String url;
  final String fileName;
  final int sizeBytes;
  final DateTime uploadedAt;
  final String supabasePath;

  String get sizeLabel {
    if (sizeBytes >= 1024 * 1024) {
      return '${(sizeBytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
  }

  factory ResumeVersion.fromMap(Map<String, dynamic> data) {
    return ResumeVersion(
      url: data['url'] as String? ?? '',
      fileName: data['fileName'] as String? ?? '',
      sizeBytes: (data['sizeBytes'] as num?)?.toInt() ?? 0,
      uploadedAt:
          (data['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      supabasePath: data['supabasePath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'url': url,
    'fileName': fileName,
    'sizeBytes': sizeBytes,
    'uploadedAt': Timestamp.fromDate(uploadedAt),
    'supabasePath': supabasePath,
  };
}

class ResumeConfig {
  const ResumeConfig({
    this.activeUrl,
    this.activeFileName,
    this.activeSizeBytes,
    this.activeSupabasePath,
    this.updatedAt,
    this.versions = const [],
  });

  final String? activeUrl;
  final String? activeFileName;
  final int? activeSizeBytes;
  final String? activeSupabasePath;
  final DateTime? updatedAt;
  final List<ResumeVersion> versions;

  bool get hasResume => activeUrl != null && activeUrl!.isNotEmpty;

  String get activeSizeLabel {
    final bytes = activeSizeBytes ?? 0;
    if (bytes >= 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  factory ResumeConfig.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final versionsList =
        (data['versions'] as List<dynamic>? ?? [])
            .map((v) => ResumeVersion.fromMap(v as Map<String, dynamic>))
            .toList();
    return ResumeConfig(
      activeUrl: data['activeUrl'] as String?,
      activeFileName: data['activeFileName'] as String?,
      activeSizeBytes: (data['activeSizeBytes'] as num?)?.toInt(),
      activeSupabasePath: data['activeSupabasePath'] as String?,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      versions: versionsList,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'activeUrl': activeUrl,
    'activeFileName': activeFileName,
    'activeSizeBytes': activeSizeBytes,
    'activeSupabasePath': activeSupabasePath,
    'updatedAt': FieldValue.serverTimestamp(),
    'versions': versions.map((v) => v.toMap()).toList(),
  };

  ResumeConfig withNewActive({
    required String url,
    required String fileName,
    required int sizeBytes,
    required String supabasePath,
  }) {
    final prev =
        (activeUrl != null && activeUrl!.isNotEmpty)
            ? ResumeVersion(
              url: activeUrl!,
              fileName: activeFileName ?? '',
              sizeBytes: activeSizeBytes ?? 0,
              uploadedAt: updatedAt ?? DateTime.now(),
              supabasePath: activeSupabasePath ?? '',
            )
            : null;

    return ResumeConfig(
      activeUrl: url,
      activeFileName: fileName,
      activeSizeBytes: sizeBytes,
      activeSupabasePath: supabasePath,
      versions: [if (prev != null) prev, ...versions],
    );
  }
}

// ─── Media Library ─────────────────────────────────────────────────────────

enum MediaAssetType { image, document, other }

class MediaAssetRecord {
  const MediaAssetRecord({
    required this.id,
    required this.name,
    required this.url,
    required this.supabasePath,
    required this.bucket,
    required this.sizeBytes,
    required this.assetType,
    required this.uploadedAt,
  });

  final String id;
  final String name;
  final String url;
  final String supabasePath;
  final String bucket;
  final int sizeBytes;
  final MediaAssetType assetType;
  final DateTime uploadedAt;

  String get sizeLabel {
    if (sizeBytes >= 1024 * 1024) {
      return '${(sizeBytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
  }

  String get uploadedLabel {
    final diff = DateTime.now().difference(uploadedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  factory MediaAssetRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return MediaAssetRecord(
      id: doc.id,
      name: data['name'] as String? ?? '',
      url: data['url'] as String? ?? '',
      supabasePath: data['supabasePath'] as String? ?? '',
      bucket: data['bucket'] as String? ?? '',
      sizeBytes: (data['sizeBytes'] as num?)?.toInt() ?? 0,
      assetType: MediaAssetType.values.firstWhere(
        (t) => t.name == (data['assetType'] as String? ?? 'other'),
        orElse: () => MediaAssetType.other,
      ),
      uploadedAt:
          (data['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'url': url,
    'supabasePath': supabasePath,
    'bucket': bucket,
    'sizeBytes': sizeBytes,
    'assetType': assetType.name,
    'uploadedAt': Timestamp.fromDate(uploadedAt),
  };
}

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

class SitePageKeys {
  const SitePageKeys._();

  static const String home = 'home';
  static const String about = 'about';
  static const String myWork = 'my_work';
  static const String resume = 'resume';
  static const String blog = 'blog';
}

class SitePageConfig {
  const SitePageConfig({
    required this.id,
    required this.key,
    required this.title,
    required this.route,
    required this.description,
    required this.isVisible,
    required this.displayOrder,
    this.updatedAt,
  });

  final String id;
  final String key;
  final String title;
  final String route;
  final String description;
  final bool isVisible;
  final int displayOrder;
  final DateTime? updatedAt;

  factory SitePageConfig.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return SitePageConfig(
      id: doc.id,
      key: data['key'] as String? ?? doc.id,
      title: data['title'] as String? ?? doc.id,
      route: data['route'] as String? ?? '/',
      description: data['description'] as String? ?? '',
      isVisible: data['isVisible'] as bool? ?? true,
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'key': key,
      'title': title,
      'route': route,
      'description': description,
      'isVisible': isVisible,
      'displayOrder': displayOrder,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  SitePageConfig copyWith({bool? isVisible}) {
    return SitePageConfig(
      id: id,
      key: key,
      title: title,
      route: route,
      description: description,
      isVisible: isVisible ?? this.isVisible,
      displayOrder: displayOrder,
      updatedAt: updatedAt,
    );
  }

  static List<SitePageConfig> defaultPages() {
    return const [
      SitePageConfig(
        id: SitePageKeys.home,
        key: SitePageKeys.home,
        title: 'Home',
        route: '/',
        description: 'Hero section, intro, and main CTA.',
        isVisible: true,
        displayOrder: 1,
      ),
      SitePageConfig(
        id: SitePageKeys.about,
        key: SitePageKeys.about,
        title: 'About Me',
        route: '/about',
        description: 'Personal story, skills, and experience timeline.',
        isVisible: true,
        displayOrder: 2,
      ),
      SitePageConfig(
        id: SitePageKeys.myWork,
        key: SitePageKeys.myWork,
        title: 'My Work',
        route: '/projects',
        description: 'Featured projects and portfolio highlights.',
        isVisible: true,
        displayOrder: 3,
      ),
      SitePageConfig(
        id: SitePageKeys.resume,
        key: SitePageKeys.resume,
        title: 'Resume',
        route: '/resume',
        description: 'Downloadable CV and career highlights.',
        isVisible: true,
        displayOrder: 4,
      ),
      SitePageConfig(
        id: SitePageKeys.blog,
        key: SitePageKeys.blog,
        title: 'Blog',
        route: '/blog',
        description: 'Articles, thoughts, and editorial content.',
        isVisible: true,
        displayOrder: 5,
      ),
    ];
  }
}

class BasicDetails {
  const BasicDetails({
    required this.name,
    required this.designation,
    this.linkedinUrl = '',
    this.twitterUrl = '',
    this.githubUrl = '',
    this.mediumUrl = '',
    this.instagramUrl = '',
    this.email = '',
    this.updatedAt,
  });

  final String name;
  final String designation;
  final String linkedinUrl;
  final String twitterUrl;
  final String githubUrl;
  final String mediumUrl;
  final String instagramUrl;
  final String email;
  final DateTime? updatedAt;

  factory BasicDetails.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return BasicDetails(
      name: data['name'] as String? ?? 'Gokul K S',
      designation: data['designation'] as String? ?? 'Flutter Developer',
      linkedinUrl: data['linkedinUrl'] as String? ?? '',
      twitterUrl: data['twitterUrl'] as String? ?? '',
      githubUrl: data['githubUrl'] as String? ?? '',
      mediumUrl: data['mediumUrl'] as String? ?? '',
      instagramUrl: data['instagramUrl'] as String? ?? '',
      email: data['email'] as String? ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'designation': designation,
      'linkedinUrl': linkedinUrl,
      'twitterUrl': twitterUrl,
      'githubUrl': githubUrl,
      'mediumUrl': mediumUrl,
      'instagramUrl': instagramUrl,
      'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  BasicDetails copyWith({
    String? name,
    String? designation,
    String? linkedinUrl,
    String? twitterUrl,
    String? githubUrl,
    String? mediumUrl,
    String? instagramUrl,
    String? email,
  }) {
    return BasicDetails(
      name: name ?? this.name,
      designation: designation ?? this.designation,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      mediumUrl: mediumUrl ?? this.mediumUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      email: email ?? this.email,
    );
  }

  static BasicDetails defaults() {
    return const BasicDetails(
      name: 'Gokul K S',
      designation: 'Flutter Developer',
      linkedinUrl: '',
      twitterUrl: '',
      githubUrl: '',
      mediumUrl: '',
      instagramUrl: '',
      email: 'gokulofficialcommunication@gmail.com',
    );
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

  ManagedSocialLink copyWith({
    String? platform,
    String? value,
    String? type,
    int? displayOrder,
    bool? isVisible,
  }) {
    return ManagedSocialLink(
      id: id,
      platform: platform ?? this.platform,
      value: value ?? this.value,
      type: type ?? this.type,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
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
