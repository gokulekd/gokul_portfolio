import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/portfolio_provider.dart';
import '../widgets/blog/widgets.dart';
import '../widgets/shared/custom_widgets.dart';

class BlogPage extends ConsumerWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(portfolioProvider).publicBlogPosts;
    // Only posts flagged as featured in the admin panel get the spotlight
    // (newest first); without one, every post goes in the grid.
    final featuredPost = posts.where((p) => p.isFeatured).firstOrNull;
    final gridPosts = posts.where((p) => p != featuredPost).toList();

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: posts.isEmpty
            ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlogHeroSection(),
                  EmptyBlogState(),
                  FooterSection(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlogHeroSection(featuredPost: featuredPost),
                  if (featuredPost != null)
                    BlogFeaturedSection(featuredPost: featuredPost),
                  if (gridPosts.isNotEmpty)
                    BlogPostsSection(
                      posts: gridPosts,
                      eyebrow: featuredPost != null
                          ? '{02} - All Posts'
                          : '{01} - All Posts',
                    ),
                  const FooterSection(),
                ],
              ),
      ),
    );
  }
}
