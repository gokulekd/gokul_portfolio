import 'package:cloud_firestore/cloud_firestore.dart';

class Experience {
  final String id;
  final String company;
  final String position;
  final String duration;
  final String description;
  final List<String> technologies;
  final int displayOrder;
  final bool isVisible;

  Experience({
    this.id = '',
    required this.company,
    required this.position,
    required this.duration,
    required this.description,
    required this.technologies,
    this.displayOrder = 0,
    this.isVisible = true,
  });

  factory Experience.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return Experience(
      id: doc.id,
      company: data['company'] as String? ?? '',
      position: data['position'] as String? ?? '',
      duration: data['duration'] as String? ?? '',
      description: data['description'] as String? ?? '',
      technologies:
          (data['technologies'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      displayOrder: (data['displayOrder'] as num?)?.toInt() ?? 0,
      isVisible: data['isVisible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'company': company,
      'position': position,
      'duration': duration,
      'description': description,
      'technologies': technologies,
      'displayOrder': displayOrder,
      'isVisible': isVisible,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Experience copyWith({
    String? company,
    String? position,
    String? duration,
    String? description,
    List<String>? technologies,
    int? displayOrder,
    bool? isVisible,
  }) {
    return Experience(
      id: id,
      company: company ?? this.company,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  static List<Experience> defaults() {
    return [
      Experience(
        id: 'sowedane-it-solutions',
        company: 'Sowedane IT Solutions Pvt.',
        position: 'Flutter Developer',
        duration: 'Oct 2022 – Oct 2025',
        description:
            'Collaborated with cross-functional teams to deliver user-focused designs using Figma, increasing app engagement by 30%. Integrated Firebase services for real-time data syncing, push notifications, and analytics. Delivered multiple projects on time, maintaining high client satisfaction rates.',
        technologies: [
          'Flutter',
          'Dart',
          'Firebase',
          'Figma',
          'GetX',
          'Bloc',
          'REST APIs',
        ],
        displayOrder: 1,
      ),
      Experience(
        id: 'brototype-kochi',
        company: 'Brototype – Kochi',
        position: 'Flutter Developer Intern',
        duration: 'Oct 2021 – Oct 2022',
        description:
            'Transformed Figma prototypes into functional, visually appealing UIs. Spearheaded Google Maps integration for precise location tracking. Implemented GetX state management to streamline app navigation and reduce complexity.',
        technologies: [
          'Flutter',
          'Dart',
          'GetX',
          'Google Maps',
          'Figma',
          'Firebase',
        ],
        displayOrder: 2,
      ),
    ];
  }
}

class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String imageUrl;
  final DateTime publishDate;
  final String author;
  final List<String> tags;
  final int readingTimeMinutes;
  final String? url;
  final int reactions;
  final bool isFeatured;

  BlogPost({
    this.id = '',
    required this.title,
    required this.excerpt,
    required this.content,
    required this.imageUrl,
    required this.publishDate,
    required this.author,
    required this.tags,
    this.readingTimeMinutes = 5,
    this.url,
    this.reactions = 0,
    this.isFeatured = false,
  });
}

class SocialLink {
  final String platform;
  final String url;
  final String icon;

  SocialLink({required this.platform, required this.url, required this.icon});
}

class PersonalInfo {
  final String name;
  final String title;
  final String email;
  final String location;
  final String bio;
  final String profileImageUrl;
  final List<SocialLink> socialLinks;

  PersonalInfo({
    required this.name,
    required this.title,
    required this.email,
    required this.location,
    required this.bio,
    required this.profileImageUrl,
    required this.socialLinks,
  });
}

class GitHubStats {
  final int publicRepos;
  final int followers;
  final int following;
  final String avatarUrl;
  final String bio;

  GitHubStats({
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.avatarUrl,
    required this.bio,
  });
}
