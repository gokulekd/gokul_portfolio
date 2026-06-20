import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/portfolio_models.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'blog_components.dart';

class BlogProfileCard extends ConsumerWidget {
  const BlogProfileCard({super.key, this.post});

  final BlogPost? post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: isMobile ? double.infinity : 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.grey[300],
            backgroundImage: const AssetImage(
              'assets/images/WhatsApp Image 2025-02-21 at 11.02.33.jpeg',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Writing Focus',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Short, practical notes around Flutter, product thinking, and interface execution.',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          BlogProfileMetric(
            value: '${ref.watch(portfolioProvider).blogPosts.length}+',
            label: 'Published posts available to read',
          ),
          const SizedBox(height: 14),
          BlogProfileMetric(
            value: post == null ? 'Live' : '${post!.readingTimeMinutes} min',
            label:
                post == null
                    ? 'Fresh writing from connected sources'
                    : 'Reading time for the featured post',
          ),
          const SizedBox(height: 14),
          BlogProfileMetric(
            value: post == null ? 'Notes' : '${post!.tags.length}',
            label:
                post == null
                    ? 'Focused on useful development insights'
                    : 'Tags attached to the featured article',
          ),
        ],
      ),
    );
  }
}
