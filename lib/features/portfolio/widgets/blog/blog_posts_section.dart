import 'package:flutter/material.dart';

import '../../models/portfolio_models.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../shared/custom_widgets.dart';
import 'blog_components.dart';

class BlogPostsSection extends StatelessWidget {
  const BlogPostsSection({super.key, required this.posts});

  final List<BlogPost> posts;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final hPad =
        isMobile
            ? 20.0
            : isTablet
            ? 48.0
            : 88.0;
    final remainingPosts = posts.length > 1 ? posts.sublist(1) : posts;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        hPad,
        isMobile ? 48 : 80,
        hPad,
        isMobile ? 48 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlogSectionHeading(
            eyebrow: '{02} - All Posts',
            title: 'Blogs shown directly underneath the hero.',
            description:
                'Browse through the writing archive in a cleaner card layout that is easier to scan on desktop and mobile.',
          ),
          const SizedBox(height: 24),
          if (remainingPosts.isEmpty)
            BlogCard(
              title: posts.first.title,
              excerpt: posts.first.excerpt,
              imageUrl: posts.first.imageUrl,
              publishDate: posts.first.publishDate,
              tags: posts.first.tags,
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final useSingleColumn = constraints.maxWidth < 1000;

                if (useSingleColumn) {
                  return Column(
                    children: [
                      for (int i = 0; i < remainingPosts.length; i++) ...[
                        BlogPostTile(post: remainingPosts[i]),
                        if (i != remainingPosts.length - 1)
                          const SizedBox(height: 24),
                      ],
                    ],
                  );
                }

                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: remainingPosts
                      .map(
                        (post) => SizedBox(
                          width: (constraints.maxWidth - 24) / 2,
                          child: BlogPostTile(post: post),
                        ),
                      )
                      .toList(growable: false),
                );
              },
            ),
        ],
      ),
    );
  }
}

class BlogPostTile extends StatelessWidget {
  const BlogPostTile({super.key, required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showBlogPost(context, post),
      child: BlogCard(
        title: post.title,
        excerpt: post.excerpt,
        imageUrl: post.imageUrl,
        publishDate: post.publishDate,
        tags: post.tags,
      ),
    );
  }
}
