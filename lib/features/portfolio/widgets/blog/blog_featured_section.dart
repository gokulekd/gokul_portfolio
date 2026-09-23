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
            title: 'Start with this one.',
            description:
                'A hand-picked post worth reading first, before diving into the rest of the archive.',
          ),
          const SizedBox(height: 24),
          FeaturedPostCard(post: featuredPost),
        ],
      ),
    );
  }
}
