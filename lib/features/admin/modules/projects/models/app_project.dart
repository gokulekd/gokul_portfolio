class AppProject {
  final String id;
  final String appName;
  final String appDescription;
  final String appIconUrl;
  final String appBannerUrl;
  final String appWebsiteUrl;
  final String? githubUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final bool isFeatured;
  final bool isPublished;
  final int displayOrder;
  final DateTime createdAt;
  final List<String> techStack;
  final String developerResponsibilities;

  const AppProject({
    this.id = '',
    required this.appName,
    required this.appDescription,
    this.appIconUrl = '',
    this.appBannerUrl = '',
    this.appWebsiteUrl = '',
    this.githubUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.isFeatured = false,
    this.isPublished = true,
    this.displayOrder = 0,
    required this.createdAt,
    this.techStack = const [],
    this.developerResponsibilities = '',
  });

  AppProject copyWith({
    String? id,
    String? appName,
    String? appDescription,
    String? appIconUrl,
    String? appBannerUrl,
    String? appWebsiteUrl,
    String? githubUrl,
    String? playStoreUrl,
    String? appStoreUrl,
    bool? isFeatured,
    bool? isPublished,
    int? displayOrder,
    DateTime? createdAt,
    List<String>? techStack,
    String? developerResponsibilities,
  }) {
    return AppProject(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      appDescription: appDescription ?? this.appDescription,
      appIconUrl: appIconUrl ?? this.appIconUrl,
      appBannerUrl: appBannerUrl ?? this.appBannerUrl,
      appWebsiteUrl: appWebsiteUrl ?? this.appWebsiteUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      techStack: techStack ?? this.techStack,
      developerResponsibilities: developerResponsibilities ?? this.developerResponsibilities,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id.isNotEmpty) 'id': id,
    'app_name': appName,
    'app_description': appDescription,
    'app_icon_url': appIconUrl,
    'app_banner_url': appBannerUrl,
    'app_website_url': appWebsiteUrl,
    'github_url': githubUrl,
    'play_store_url': playStoreUrl,
    'app_store_url': appStoreUrl,
    'is_featured': isFeatured,
    'is_published': isPublished,
    'display_order': displayOrder,
    'created_at': createdAt.toIso8601String(),
    'tech_stack': techStack,
    'developer_responsibilities': developerResponsibilities,
  };

  factory AppProject.fromJson(Map<String, dynamic> json) => AppProject(
    id: (json['id'] ?? '').toString(),
    appName: json['app_name'] as String? ?? '',
    appDescription: json['app_description'] as String? ?? '',
    appIconUrl: json['app_icon_url'] as String? ?? '',
    appBannerUrl: json['app_banner_url'] as String? ?? '',
    appWebsiteUrl: json['app_website_url'] as String? ?? '',
    githubUrl: json['github_url'] as String?,
    playStoreUrl: json['play_store_url'] as String?,
    appStoreUrl: json['app_store_url'] as String?,
    isFeatured: json['is_featured'] as bool? ?? false,
    isPublished: json['is_published'] as bool? ?? true,
    displayOrder: json['display_order'] as int? ?? 0,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : DateTime.now(),
    techStack: (json['tech_stack'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    developerResponsibilities:
        json['developer_responsibilities'] as String? ?? '',
  );
}
