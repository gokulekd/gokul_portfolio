/// Blog post authored from the admin portal, persisted to Supabase (table
/// `blog_posts`) — not Firestore. Day 9 decision: blog posts move to
/// Supabase because they need cover images, and Firebase has no Storage on
/// the Spark plan; Supabase already handles every other file upload
/// (project banners/icons, resume, media library), so this follows the same
/// pattern as `AppProject`.
///
/// Distinct from the read-only `BlogPost` model in `portfolio_models.dart`,
/// which represents articles pulled live from the Dev.to API and stays a
/// supplementary feed (toggled via `BlogSettings`).
class AdminBlogPost {
  const AdminBlogPost({
    this.id = '',
    required this.title,
    required this.excerpt,
    this.content = '',
    this.coverImageUrl = '',
    this.tags = const [],
    this.authorName = '',
    this.readingTimeMinutes = 5,
    this.isPublished = true,
    this.isFeatured = false,
    this.displayOrder = 0,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String coverImageUrl;
  final List<String> tags;
  final String authorName;
  final int readingTimeMinutes;
  final bool isPublished;
  final bool isFeatured;
  final int displayOrder;
  final DateTime createdAt;

  AdminBlogPost copyWith({
    String? id,
    String? title,
    String? excerpt,
    String? content,
    String? coverImageUrl,
    List<String>? tags,
    String? authorName,
    int? readingTimeMinutes,
    bool? isPublished,
    bool? isFeatured,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return AdminBlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      content: content ?? this.content,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      tags: tags ?? this.tags,
      authorName: authorName ?? this.authorName,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
      isPublished: isPublished ?? this.isPublished,
      isFeatured: isFeatured ?? this.isFeatured,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id.isNotEmpty) 'id': id,
    'title': title,
    'excerpt': excerpt,
    'content': content,
    'cover_image_url': coverImageUrl,
    'tags': tags,
    'author_name': authorName,
    'reading_time_minutes': readingTimeMinutes,
    'is_published': isPublished,
    'is_featured': isFeatured,
    'display_order': displayOrder,
    'created_at': createdAt.toIso8601String(),
  };

  factory AdminBlogPost.fromJson(Map<String, dynamic> json) => AdminBlogPost(
    id: (json['id'] ?? '').toString(),
    title: json['title'] as String? ?? '',
    excerpt: json['excerpt'] as String? ?? '',
    content: json['content'] as String? ?? '',
    coverImageUrl: json['cover_image_url'] as String? ?? '',
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    authorName: json['author_name'] as String? ?? '',
    readingTimeMinutes: json['reading_time_minutes'] as int? ?? 5,
    isPublished: json['is_published'] as bool? ?? true,
    isFeatured: json['is_featured'] as bool? ?? false,
    displayOrder: json['display_order'] as int? ?? 0,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : DateTime.now(),
  );
}
