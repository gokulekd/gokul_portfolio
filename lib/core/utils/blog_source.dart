import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Where an externally published blog post lives, derived from its URL's
/// host. Drives the platform badge on blog cards ("Medium", "LinkedIn"...).
class BlogSource {
  const BlogSource({required this.name, required this.icon, required this.color});

  final String name;
  final IconData icon;

  /// Brand color, used for the badge icon. Near-black brands (Medium, X,
  /// Notion...) are null so the badge falls back to the theme's text color
  /// and stays visible in dark mode.
  final Color? color;

  static BlogSource? fromUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
    if (host.isEmpty) return null;
    bool on(String domain) => host == domain || host.endsWith('.$domain');

    if (on('medium.com')) {
      return const BlogSource(name: 'Medium', icon: FontAwesomeIcons.medium, color: null);
    }
    if (on('linkedin.com') || host == 'lnkd.in') {
      return const BlogSource(
        name: 'LinkedIn',
        icon: FontAwesomeIcons.linkedinIn,
        color: Color(0xFF0A66C2),
      );
    }
    if (on('notion.site') || on('notion.so')) {
      return const BlogSource(name: 'Notion', icon: FontAwesomeIcons.n, color: null);
    }
    if (on('reddit.com') || host == 'redd.it') {
      return const BlogSource(
        name: 'Reddit',
        icon: FontAwesomeIcons.redditAlien,
        color: Color(0xFFFF4500),
      );
    }
    if (on('dev.to')) {
      return const BlogSource(name: 'DEV', icon: FontAwesomeIcons.dev, color: null);
    }
    if (on('hashnode.dev') || on('hashnode.com')) {
      return const BlogSource(
        name: 'Hashnode',
        icon: FontAwesomeIcons.hashnode,
        color: Color(0xFF2962FF),
      );
    }
    if (on('substack.com')) {
      return const BlogSource(
        name: 'Substack',
        icon: FontAwesomeIcons.bookmark,
        color: Color(0xFFFF6719),
      );
    }
    if (on('x.com') || on('twitter.com')) {
      return const BlogSource(name: 'X', icon: FontAwesomeIcons.xTwitter, color: null);
    }
    if (on('youtube.com') || host == 'youtu.be') {
      return const BlogSource(
        name: 'YouTube',
        icon: FontAwesomeIcons.youtube,
        color: Color(0xFFFF0000),
      );
    }
    if (on('github.com') || on('github.io')) {
      return const BlogSource(name: 'GitHub', icon: FontAwesomeIcons.github, color: null);
    }
    if (on('stackoverflow.com')) {
      return const BlogSource(
        name: 'Stack Overflow',
        icon: FontAwesomeIcons.stackOverflow,
        color: Color(0xFFF48024),
      );
    }

    // Anything else: show the site name, e.g. "blog.example.com" → "Example".
    final parts = host.replaceFirst(RegExp(r'^www\.'), '').split('.');
    final label = parts.length >= 2 ? parts[parts.length - 2] : parts.first;
    return BlogSource(
      name: label.isEmpty ? host : '${label[0].toUpperCase()}${label.substring(1)}',
      icon: Icons.public_rounded,
      color: null,
    );
  }
}
