import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/portfolio_controller.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';

class BlogPost {
  BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.tags,
    required this.publishDate,
    required this.readingTimeMinutes,
    this.isPublished = false,
    this.isExternal = false,
    this.externalUrl,
  });

  final String id;
  final String title;
  final String excerpt;
  final List<String> tags;
  final DateTime publishDate;
  final int readingTimeMinutes;
  final bool isPublished;
  final bool isExternal;
  final String? externalUrl;

  BlogPost copyWith({
    String? title,
    String? excerpt,
    List<String>? tags,
    int? readingTimeMinutes,
    bool? isPublished,
  }) => BlogPost(
    id: id,
    title: title ?? this.title,
    excerpt: excerpt ?? this.excerpt,
    tags: tags ?? this.tags,
    publishDate: publishDate,
    readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
    isPublished: isPublished ?? this.isPublished,
    isExternal: isExternal,
    externalUrl: externalUrl,
  );
}

class BlogWorkspace extends StatefulWidget {
  const BlogWorkspace({super.key, required this.isCompact});
  final bool isCompact;

  @override
  State<BlogWorkspace> createState() => _BlogWorkspaceState();
}

class _BlogWorkspaceState extends State<BlogWorkspace> {
  late final List<BlogPost> _posts;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    final portfolioController = Get.find<PortfolioController>();
    _posts = [
      ...portfolioController.blogPosts.map(
        (p) => BlogPost(
          id: p.url ?? p.title,
          title: p.title,
          excerpt: p.excerpt,
          tags: p.tags,
          publishDate: p.publishDate,
          readingTimeMinutes: p.readingTimeMinutes,
          isPublished: true,
          isExternal: true,
          externalUrl: p.url,
        ),
      ),
    ];
  }

  List<BlogPost> get _filtered {
    return switch (_filter) {
      'Published' => _posts.where((p) => p.isPublished).toList(),
      'Draft' => _posts.where((p) => !p.isPublished).toList(),
      'Dev.to' => _posts.where((p) => p.isExternal).toList(),
      _ => _posts,
    };
  }

  void _openDialog({BlogPost? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final excerptCtrl = TextEditingController(text: existing?.excerpt ?? '');
    final tagsCtrl = TextEditingController(
      text: existing?.tags.join(', ') ?? '',
    );
    int readTime = existing?.readingTimeMinutes ?? 5;
    bool isPublished = existing?.isPublished ?? false;

    showDialog<void>(
      context: context,
      builder:
          (ctx) => StatefulBuilder(
            builder:
                (ctx, setDlg) => AlertDialog(
                  backgroundColor: const Color(0xFF1A1C1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    existing == null ? 'New post' : 'Edit post',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DialogField(
                          controller: titleCtrl,
                          label: 'Title',
                          hint: 'Post title…',
                        ),
                        const SizedBox(height: 14),
                        DialogField(
                          controller: excerptCtrl,
                          label: 'Excerpt',
                          hint: 'Short summary shown in the blog list…',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 14),
                        DialogField(
                          controller: tagsCtrl,
                          label: 'Tags (comma separated)',
                          hint: 'Flutter, Firebase, Tutorial',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text(
                              'Read time',
                              style: GoogleFonts.manrope(
                                color: Colors.white54,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$readTime min',
                              style: GoogleFonts.manrope(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: readTime.toDouble(),
                          min: 1,
                          max: 30,
                          divisions: 29,
                          activeColor: AppColors.primaryGreen,
                          inactiveColor: Colors.white12,
                          onChanged: (v) => setDlg(() => readTime = v.round()),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Publish immediately',
                              style: GoogleFonts.manrope(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Switch(
                              value: isPublished,
                              onChanged: (v) => setDlg(() => isPublished = v),
                              activeThumbColor: AppColors.primaryGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.manrope(color: Colors.white54),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final title = titleCtrl.text.trim();
                        final excerpt = excerptCtrl.text.trim();
                        if (title.isEmpty || excerpt.isEmpty) return;
                        final tags =
                            tagsCtrl.text
                                .split(',')
                                .map((t) => t.trim())
                                .where((t) => t.isNotEmpty)
                                .toList();
                        setState(() {
                          if (existing != null) {
                            final idx = _posts.indexWhere(
                              (p) => p.id == existing.id,
                            );
                            if (idx != -1) {
                              _posts[idx] = existing.copyWith(
                                title: title,
                                excerpt: excerpt,
                                tags: tags,
                                readingTimeMinutes: readTime,
                                isPublished: isPublished,
                              );
                            }
                          } else {
                            _posts.insert(
                              0,
                              BlogPost(
                                id:
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                title: title,
                                excerpt: excerpt,
                                tags: tags,
                                publishDate: DateTime.now(),
                                readingTimeMinutes: readTime,
                                isPublished: isPublished,
                              ),
                            );
                          }
                        });
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.manrope(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final publishedCount = _posts.where((p) => p.isPublished).length;
    final draftCount = _posts.where((p) => !p.isPublished).length;
    final externalCount = _posts.where((p) => p.isExternal).length;

    final postList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'BLOG CMS',
            title: 'Posts & articles',
            description:
                '${_posts.length} total posts — $externalCount synced from Dev.to, ${_posts.length - externalCount} portfolio-only.',
            action: AdminPrimaryButton(
              label: 'New post',
              icon: Icons.add_rounded,
              onPressed: () => _openDialog(),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ['All', 'Published', 'Draft', 'Dev.to'].map((f) {
                    final active = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color:
                                active
                                    ? AppColors.primaryGreen.withValues(
                                      alpha: 0.16,
                                    )
                                    : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color:
                                  active
                                      ? AppColors.primaryGreen.withValues(
                                        alpha: 0.4,
                                      )
                                      : Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Text(
                            f,
                            style: GoogleFonts.manrope(
                              color:
                                  active
                                      ? AppColors.primaryGreen
                                      : Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          if (filtered.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No posts match this filter.',
                  style: GoogleFonts.manrope(color: Colors.white38),
                ),
              ),
            )
          else
            ...filtered.map(
              (post) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BlogPostRow(
                  post: post,
                  onEdit:
                      post.isExternal
                          ? null
                          : () => _openDialog(existing: post),
                  onDelete:
                      post.isExternal
                          ? null
                          : () => setState(
                            () => _posts.removeWhere((p) => p.id == post.id),
                          ),
                  onTogglePublish:
                      post.isExternal
                          ? null
                          : (val) {
                            setState(() {
                              final idx = _posts.indexWhere(
                                (p) => p.id == post.id,
                              );
                              if (idx != -1) {
                                _posts[idx] = post.copyWith(isPublished: val);
                              }
                            });
                          },
                ),
              ),
            ),
        ],
      ),
    );

    final statsPanel = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminSectionHeader(
            eyebrow: 'BLOG STATS',
            title: 'Post overview',
            description: 'Summary of your blog content and publish states.',
          ),
          const SizedBox(height: 18),
          PreviewTile(
            title: 'Total posts',
            value: '${_posts.length} articles',
            icon: Icons.article_rounded,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Published',
            value: '$publishedCount live',
            icon: Icons.visibility_rounded,
            color: const Color(0xFF5CD6FF),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Drafts',
            value: '$draftCount unpublished',
            icon: Icons.edit_note_rounded,
            color: const Color(0xFFFFB44C),
          ),
          const SizedBox(height: 12),
          PreviewTile(
            title: 'Synced from Dev.to',
            value: '$externalCount external articles',
            icon: Icons.sync_rounded,
            color: const Color(0xFFB57AFF),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(
        children: [postList, const SizedBox(height: 18), statsPanel],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 8, child: postList),
        const SizedBox(width: 18),
        Expanded(flex: 4, child: statsPanel),
      ],
    );
  }
}

class BlogPostRow extends StatelessWidget {
  const BlogPostRow({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePublish,
  });

  final BlogPost post;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onTogglePublish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        post.title,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (post.isExternal)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFB57AFF,
                          ).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Dev.to',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFFB57AFF),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const SizedBox(width: 6),
                    AdminStateChip(
                      state:
                          post.isPublished
                              ? AdminItemState.live
                              : AdminItemState.draft,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  post.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    color: Colors.white60,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...post.tags
                        .take(3)
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '#$tag',
                              style: GoogleFonts.manrope(
                                color: Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${post.readingTimeMinutes} min read',
                        style: GoogleFonts.manrope(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Transform.scale(
                scale: 0.82,
                child: Switch(
                  value: post.isPublished,
                  onChanged: onTogglePublish,
                  activeThumbColor: AppColors.primaryGreen,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white54,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFFF7C7C),
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
