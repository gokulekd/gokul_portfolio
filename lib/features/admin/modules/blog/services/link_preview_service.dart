import 'dart:convert';

import 'package:http/http.dart' as http;

class LinkPreview {
  const LinkPreview({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.publishedAt,
  });

  final String title;
  final String description;
  final String imageUrl;
  final DateTime? publishedAt;
}

/// Reads a public page's title, summary, cover image and date so an external
/// post (Medium, LinkedIn...) can be added by pasting its URL.
///
/// The browser can't fetch those pages directly (no CORS headers), and the
/// Spark plan has no Cloud Functions, so this goes through microlink.io's
/// free tier (CORS-enabled, ~50 lookups/day, no key). Returns null when the
/// lookup fails; the admin can then fill the fields in by hand.
class LinkPreviewService {
  Future<LinkPreview?> fetch(String url) async {
    try {
      final uri = Uri.https('api.microlink.io', '/', {'url': url});
      final response = await http.get(uri).timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['status'] != 'success') return null;
      final data = body['data'] as Map<String, dynamic>? ?? const {};

      final image = data['image'];
      final title = (data['title'] as String? ?? '').trim();
      final description = (data['description'] as String? ?? '').trim();
      if (title.isEmpty && description.isEmpty) return null;

      return LinkPreview(
        title: title,
        description: description,
        imageUrl: image is Map ? (image['url'] as String? ?? '') : '',
        publishedAt: DateTime.tryParse(data['date'] as String? ?? ''),
      );
    } catch (_) {
      return null;
    }
  }
}
