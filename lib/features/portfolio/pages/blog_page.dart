import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/portfolio_provider.dart';
import '../widgets/blog/blog_widgets.dart';
import '../widgets/shared/custom_widgets.dart';
import '../widgets/shared/footer_section.dart';

class BlogPage extends ConsumerWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(portfolioProvider).blogPosts;

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
                  BlogHeroSection(featuredPost: posts.first),
                  BlogFeaturedSection(featuredPost: posts.first),
                  BlogPostsSection(posts: posts),
                  const FooterSection(),
                ],
              ),
      ),
    );
  }
}
