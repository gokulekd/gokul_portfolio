class Experience {
  final String company;
  final String position;
  final String duration;
  final String description;
  final List<String> technologies;

  Experience({
    required this.company,
    required this.position,
    required this.duration,
    required this.description,
    required this.technologies,
  });
}

class Project {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final String category;
  final int stars;
  final int forks;

  Project({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    required this.category,
    this.stars = 0,
    this.forks = 0,
  });
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
