import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/portfolio_models.dart';

class GitHubService {
  static const String _baseUrl = 'https://api.github.com';

  // ⚡ Replace with your real GitHub username
  static const String username = 'gokulks';

  static Future<List<Project>> fetchRepositories() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/users/$username/repos?sort=stars&per_page=8&type=public',
            ),
            headers: {'Accept': 'application/vnd.github.v3+json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .where((repo) => !(repo['fork'] ?? false))
            .map(
              (repo) => Project(
                title: _formatRepoName(repo['name'] ?? ''),
                description:
                    repo['description'] ?? 'No description available.',
                imageUrl:
                    'https://opengraph.githubassets.com/1/${repo['full_name']}',
                technologies: _extractTech(repo),
                githubUrl: repo['html_url'],
                liveUrl:
                    (repo['homepage'] != null && repo['homepage'].isNotEmpty)
                        ? repo['homepage']
                        : null,
                category: _categorize(repo),
                stars: repo['stargazers_count'] ?? 0,
                forks: repo['forks_count'] ?? 0,
              ),
            )
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<GitHubStats?> fetchUserStats() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/users/$username'),
            headers: {'Accept': 'application/vnd.github.v3+json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GitHubStats(
          publicRepos: data['public_repos'] ?? 0,
          followers: data['followers'] ?? 0,
          following: data['following'] ?? 0,
          avatarUrl: data['avatar_url'] ?? '',
          bio: data['bio'] ?? '',
        );
      }
    } catch (_) {}
    return null;
  }

  static String _formatRepoName(String name) {
    return name
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w,
        )
        .join(' ');
  }

  static List<String> _extractTech(Map<String, dynamic> repo) {
    final topics = List<String>.from(repo['topics'] ?? []);
    if (repo['language'] != null) {
      topics.insert(0, repo['language']);
    }
    return topics.take(4).toList();
  }

  static String _categorize(Map<String, dynamic> repo) {
    final topics = List<String>.from(repo['topics'] ?? []);
    final lang = (repo['language'] ?? '').toString().toLowerCase();

    if (topics.any((t) => ['flutter', 'mobile', 'android', 'ios'].contains(t))) {
      return 'Mobile App';
    }
    if (topics.any(
      (t) => ['web', 'website', 'flutter-web', 'nextjs', 'react'].contains(t),
    )) {
      return 'Web App';
    }
    if (lang == 'dart' || lang == 'kotlin' || lang == 'swift') {
      return 'Mobile App';
    }
    if (lang == 'javascript' ||
        lang == 'typescript' ||
        lang == 'html' ||
        lang == 'css') {
      return 'Web App';
    }
    return 'Other';
  }
}
