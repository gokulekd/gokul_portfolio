import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/portfolio/models/portfolio_models.dart';

class GitHubService {
  static const String _baseUrl = 'https://api.github.com';

  // ⚡ Replace with your real GitHub username
  static const String username = 'gokulks';

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
}
