import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/portfolio_models.dart';

class DevToService {
  static const String _baseUrl = 'https://dev.to/api';

  // ⚡ Replace with your real Dev.to username
  static const String username = 'gokulks';

  static Future<List<BlogPost>> fetchArticles({int perPage = 6}) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl/articles?username=$username&per_page=$perPage',
            ),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (article) => BlogPost(
                title: article['title'] ?? '',
                excerpt: article['description'] ?? '',
                content: article['body_markdown'] ?? '',
                imageUrl: article['cover_image'] ??
                    article['social_image'] ??
                    'https://via.placeholder.com/800x400/6366f1/ffffff?text=${Uri.encodeComponent(article['title'] ?? 'Blog')}',
                publishDate: DateTime.tryParse(
                      article['published_at'] ?? '',
                    ) ??
                    DateTime.now(),
                author:
                    article['user']?['name'] ?? article['user']?['username'] ?? username,
                tags: List<String>.from(article['tag_list'] ?? []),
                readingTimeMinutes: article['reading_time_minutes'] ?? 5,
                url: article['url'],
                reactions: article['positive_reactions_count'] ?? 0,
              ),
            )
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
