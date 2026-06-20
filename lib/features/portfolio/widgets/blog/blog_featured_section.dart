import 'package:flutter/material.dart';

import '../../models/portfolio_models.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'blog_components.dart';

class BlogFeaturedSection extends StatelessWidget {
  const BlogFeaturedSection({super.key, required this.featuredPost});

  final BlogPost featuredPost;

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

    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, isMobile ? 48 : 80, hPad, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BlogSectionHeading(
            eyebrow: '{01} - Featured Story',
            title: 'A highlighted post right at the top.',
            description:
                'The latest or most important write-up gets a larger spotlight before the full list of posts below.',
          ),
          const SizedBox(height: 24),
          FeaturedPostCard(post: featuredPost),
        ],
      ),
    );
  }
}
