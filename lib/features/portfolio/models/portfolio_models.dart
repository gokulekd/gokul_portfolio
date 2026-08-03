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

class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final String category;
  final int stars;
  final int forks;
  final bool isFeatured;
  final bool isPublished;
  final int displayOrder;

  const Project({
    this.id = '',
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    required this.category,
    this.stars = 0,
    this.forks = 0,
    this.isFeatured = false,
    this.isPublished = true,
    this.displayOrder = 0,
  });

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    List<String>? technologies,
    String? githubUrl,
    String? liveUrl,
    String? category,
    int? stars,
    int? forks,
    bool? isFeatured,
    bool? isPublished,
    int? displayOrder,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      technologies: technologies ?? this.technologies,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      category: category ?? this.category,
      stars: stars ?? this.stars,
      forks: forks ?? this.forks,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  static List<Project> defaultPortfolioProjects() {
    return const [
      Project(
        id: 'ecommerce-mobile-app',
        title: 'E-Commerce Mobile App',
        description:
            'A full-featured e-commerce application with user authentication, product catalog, shopping cart, and payment integration.',
        imageUrl:
            'https://via.placeholder.com/400x300/6366f1/ffffff?text=E-Commerce',
        technologies: ['Flutter', 'Firebase', 'Stripe', 'Provider'],
        githubUrl: 'https://github.com/gokulks/ecommerce-app',
        category: 'Mobile App',
        isFeatured: true,
        isPublished: true,
        displayOrder: 1,
      ),
      Project(
        id: 'task-management-app',
        title: 'Task Management App',
        description:
            'A productivity app for managing tasks, projects, and team collaboration with real-time updates.',
        imageUrl:
            'https://via.placeholder.com/400x300/10b981/ffffff?text=Task+Manager',
        technologies: ['Flutter', 'Firebase', 'GetX', 'Material Design'],
        githubUrl: 'https://github.com/gokulks/task-manager',
        category: 'Mobile App',
        isFeatured: true,
        isPublished: true,
        displayOrder: 2,
      ),
      Project(
        id: 'weather-forecast-app',
        title: 'Weather Forecast App',
        description:
            'Beautiful weather app with location-based forecasts, detailed weather information, and customizable themes.',
        imageUrl:
            'https://via.placeholder.com/400x300/3b82f6/ffffff?text=Weather',
        technologies: ['Flutter', 'OpenWeather API', 'Geolocator', 'Provider'],
        githubUrl: 'https://github.com/gokulks/weather-app',
        category: 'Mobile App',
        isFeatured: false,
        isPublished: true,
        displayOrder: 3,
      ),
      Project(
        id: 'portfolio-website',
        title: 'Portfolio Website',
        description:
            'Responsive portfolio website built with Flutter Web showcasing projects, skills, and service positioning.',
        imageUrl:
            'https://via.placeholder.com/400x300/8b5cf6/ffffff?text=Portfolio',
        technologies: ['Flutter Web', 'GetX', 'Responsive Design'],
        githubUrl: 'https://github.com/gokulks/portfolio',
        liveUrl: 'https://gokulks.dev',
        category: 'Web App',
        isFeatured: false,
        isPublished: true,
        displayOrder: 4,
      ),
    ];
  }
}

class BlogPost {
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

  BlogPost({
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
