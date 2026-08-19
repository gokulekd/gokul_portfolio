// Supabase-backed testimonial model. Replaces the old Firestore
// `TestimonialItem` (admin-authored only) now that testimonials are
// collected from a public submission page (`/leave-a-review`) and need a
// moderation workflow before they go live — Firestore/Spark has no concept
// of "pending review", and photo uploads need real file storage anyway
// (see `SupabaseStorageService`), so the whole collection lives in Supabase
// now, same reasoning as the blog/projects migration.
class TestimonialStatus {
  const TestimonialStatus._();

  /// Just submitted by a visitor — not shown on the portfolio yet.
  static const pending = 'pending';

  /// Reviewed and approved — shown on the portfolio.
  static const published = 'published';

  /// Reviewed and rejected/hidden — kept for record, not shown.
  static const hidden = 'hidden';
}

class TestimonialEntry {
  const TestimonialEntry({
    this.id = '',
    required this.rating,
    required this.text,
    required this.authorName,
    required this.authorRole,
    this.avatarUrl = '',
    this.status = TestimonialStatus.pending,
    this.displayOrder = 0,
    required this.createdAt,
  });

  final String id;
  final double rating;
  final String text;
  final String authorName;
  final String authorRole;
  final String avatarUrl;
  final String status;
  final int displayOrder;
  final DateTime createdAt;

  bool get isPending => status == TestimonialStatus.pending;
  bool get isVisible => status == TestimonialStatus.published;
  bool get isHidden => status == TestimonialStatus.hidden;

  factory TestimonialEntry.fromJson(Map<String, dynamic> json) {
    return TestimonialEntry(
      id: (json['id'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      text: json['message'] as String? ?? '',
      authorName: json['name'] as String? ?? '',
      authorRole: json['role'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      status: json['status'] as String? ?? TestimonialStatus.pending,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id.isNotEmpty) 'id': id,
    'rating': rating,
    'message': text,
    'name': authorName,
    'role': authorRole,
    'avatar_url': avatarUrl,
    'status': status,
    'display_order': displayOrder,
    'created_at': createdAt.toIso8601String(),
  };

  TestimonialEntry copyWith({
    String? id,
    double? rating,
    String? text,
    String? authorName,
    String? authorRole,
    String? avatarUrl,
    String? status,
    int? displayOrder,
    DateTime? createdAt,
  }) {
    return TestimonialEntry(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      text: text ?? this.text,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
