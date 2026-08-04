import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../core/providers/admin_portal_provider.dart';
import '../../../../core/providers/portfolio_provider.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/services/supabase_storage_service.dart';
import '../../../../core/supabase/supabase_bootstrap.dart';
import '../../../portfolio/models/firebase_content_models.dart';
import '../../models/admin_portal_models.dart';
import '../../shared/admin_portal_components.dart';
import '../../shared/dialog_widgets.dart';
import '../../shared/preview_tile.dart';
import '../projects/widgets/form_widgets.dart';
import 'models/admin_blog_post.dart';

/// Firestore-backed Dev.to toggle + Supabase-backed post list/edit/delete.
/// Post *authoring* (the rich compose UX) lives in `CreatePostWorkspace` —
/// this is the manage/list surface, same division of labor as the original
/// nav copy described ("Manage article states, metadata, and publishing
/// readiness" vs. "Write rich posts... Publish directly").
class BlogWorkspace extends ConsumerStatefulWidget {
  const BlogWorkspace({super.key, required this.isCompact});
  final bool isCompact;

  @override
  ConsumerState<BlogWorkspace> createState() => _BlogWorkspaceState();
}

class _BlogWorkspaceState extends ConsumerState<BlogWorkspace> {
  String _filter = 'All';

  Future<void> _pickAndUploadCover(
    BuildContext ctx,
    StateSetter setDlgState,
    TextEditingController urlController, {
    required void Function(bool) setUploading,
    required void Function(String) setPreview,
  }) async {
    if (!SupabaseBootstrap.isReady) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Storage not configured — Add SUPABASE_URL and SUPABASE_ANON_KEY.',
            style: GoogleFonts.manrope(color: Colors.white),
          ),
          backgroundColor: Colors.orange.withValues(alpha: 0.85),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    setDlgState(() => setUploading(true));
    final storage = ref.read(supabaseStorageServiceProvider);
    final uploadResult = await storage.uploadFromBytes(
      bucket: SupabaseStorageService.mediaBucket,
      folder: 'media/blog-covers',
      fileName: file.name,
      bytes: bytes,
    );

    if (uploadResult != null) {
      urlController.text = uploadResult.url;
      setDlgState(() {
        setUploading(false);
        setPreview(uploadResult.url);
      });
    } else {
      setDlgState(() => setUploading(false));
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Upload failed — Check Supabase storage config.',
                style: GoogleFonts.manrope(color: Colors.white)),
            backgroundColor: Colors.red.withValues(alpha: 0.85),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        );
      }
    }
  }

  void _openDialog(List<AdminBlogPost> posts, {AdminBlogPost? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final excerptCtrl = TextEditingController(text: existing?.excerpt ?? '');
    final contentCtrl = TextEditingController(text: existing?.content ?? '');
    final coverUrlCtrl = TextEditingController(text: existing?.coverImageUrl ?? '');
    final tagsInputCtrl = TextEditingController();
    var tags = List<String>.from(existing?.tags ?? []);
    var coverPreview = existing?.coverImageUrl ?? '';
    var isUploading = false;
    int readTime = existing?.readingTimeMinutes ?? 5;
    bool isPublished = existing?.isPublished ?? true;
    bool isFeatured = existing?.isFeatured ?? false;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          backgroundColor: const Color(0xFF1A1C1F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            existing == null ? 'New post' : 'Edit post',
            style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: isUploading
                        ? null
                        : () => _pickAndUploadCover(
                              ctx,
                              setDlg,
                              coverUrlCtrl,
                              setUploading: (v) => isUploading = v,
                              setPreview: (url) => coverPreview = url,
                            ),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: coverPreview.isNotEmpty
                          ? Image.network(
                              coverPreview,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_not_supported_rounded,
                                color: Colors.white24,
                              ),
                            )
                          : Center(
                              child: isUploading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
                                      ),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add_photo_alternate_rounded,
                                            color: Colors.white.withValues(alpha: 0.25), size: 26),
                                        const SizedBox(height: 6),
                                        Text('Click to upload cover image',
                                            style: GoogleFonts.manrope(color: Colors.white30, fontSize: 12.5)),
                                      ],
                                    ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DialogField(controller: titleCtrl, label: 'Title', hint: 'Post title…'),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: excerptCtrl,
                    label: 'Excerpt',
                    hint: 'Short summary shown in the blog list…',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 14),
                  DialogField(
                    controller: contentCtrl,
                    label: 'Content',
                    hint: 'Full post body…',
                    maxLines: 8,
                  ),
                  const SizedBox(height: 14),
                  TechStackInput(
                    tags: tags,
                    inputController: tagsInputCtrl,
                    onAdd: (tag) => setDlg(() => tags = [...tags, tag]),
                    onRemove: (tag) => setDlg(() => tags = tags.where((t) => t != tag).toList()),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text('Read time',
                          style: GoogleFonts.manrope(color: Colors.white54, fontSize: 11.5, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text('$readTime min',
                          style: GoogleFonts.manrope(color: AppColors.primaryGreen, fontWeight: FontWeight.w700)),
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
                      Text('Featured', style: GoogleFonts.manrope(color: Colors.white70, fontSize: 13)),
                      Switch(
                        value: isFeatured,
                        onChanged: (v) => setDlg(() => isFeatured = v),
                        activeThumbColor: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Published', style: GoogleFonts.manrope(color: Colors.white70, fontSize: 13)),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: GoogleFonts.manrope(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () async {
                final title = titleCtrl.text.trim();
                final excerpt = excerptCtrl.text.trim();
                if (title.isEmpty || excerpt.isEmpty) return;
                final post = AdminBlogPost(
                  id: existing?.id ?? '',
                  title: title,
                  excerpt: excerpt,
                  content: contentCtrl.text.trim(),
                  coverImageUrl: coverUrlCtrl.text.trim(),
                  tags: tags,
                  authorName: existing?.authorName ??
                      ref.read(portfolioProvider).personalInfo.name,
                  readingTimeMinutes: readTime,
                  isPublished: isPublished,
                  isFeatured: isFeatured,
                  displayOrder: existing?.displayOrder ?? posts.length + 1,
                  createdAt: existing?.createdAt ?? DateTime.now(),
                );
                final ok = await ref.read(adminPortalProvider.notifier).saveBlogPost(post);
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok ? '$title was saved.' : 'Could not save. Check Supabase config.',
                        style: GoogleFonts.manrope(color: Colors.white),
                      ),
                      backgroundColor: (ok ? AppColors.primaryGreen : Colors.orange).withValues(alpha: 0.85),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  );
                }
              },
              child: Text('Save', style: GoogleFonts.manrope(color: AppColors.primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(portfolioProvider.select((s) => s.adminBlogPosts));
    final devToCount = ref.watch(portfolioProvider.select((s) => s.blogPosts.length));
    final showDevToFeed = ref.watch(portfolioProvider.select((s) => s.showDevToFeed));

    final filtered = switch (_filter) {
      'Published' => posts.where((p) => p.isPublished).toList(),
      'Draft' => posts.where((p) => !p.isPublished).toList(),
      'Featured' => posts.where((p) => p.isFeatured).toList(),
      _ => posts,
    };
    final publishedCount = posts.where((p) => p.isPublished).length;
    final draftCount = posts.where((p) => !p.isPublished).length;

    final postList = AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeader(
            eyebrow: 'BLOG CMS',
            title: 'Posts & articles',
            description:
                '${posts.length} portfolio posts (Supabase) · $devToCount synced from Dev.to.',
            action: AdminPrimaryButton(
              label: 'New post',
              icon: Icons.add_rounded,
              onPressed: () => _openDialog(posts),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Show Dev.to feed on the public blog page',
                    style: GoogleFonts.manrope(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
                Switch(
                  value: showDevToFeed,
                  onChanged: (v) => ref
                      .read(adminPortalProvider.notifier)
                      .saveBlogSettings(BlogSettings(showDevToFeed: v)),
                  activeThumbColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Published', 'Draft', 'Featured'].map((f) {
                final active = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primaryGreen.withValues(alpha: 0.16)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: active
                              ? AppColors.primaryGreen.withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.manrope(
                          color: active ? AppColors.primaryGreen : Colors.white54,
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
                  posts.isEmpty ? 'No posts yet. Add one above.' : 'No posts match this filter.',
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
                  onEdit: () => _openDialog(posts, existing: post),
                  onDelete: () async {
                    final ok = await ref.read(adminPortalProvider.notifier).deleteBlogPost(post.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok ? '${post.title} was deleted.' : 'Could not delete. Check Supabase config.',
                            style: GoogleFonts.manrope(color: Colors.white),
                          ),
                          backgroundColor:
                              (ok ? const Color(0xFFFF7C7C) : Colors.orange).withValues(alpha: 0.85),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      );
                    }
                  },
                  onTogglePublish: (val) => ref
                      .read(adminPortalProvider.notifier)
                      .saveBlogPost(post.copyWith(isPublished: val)),
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
            title: 'Portfolio posts',
            value: '${posts.length} articles',
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
            title: 'Dev.to feed',
            value: showDevToFeed ? '$devToCount articles shown' : 'Hidden from public page',
            icon: Icons.sync_rounded,
            color: const Color(0xFFB57AFF),
          ),
        ],
      ),
    );

    if (widget.isCompact) {
      return Column(children: [postList, const SizedBox(height: 18), statsPanel]);
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

  final AdminBlogPost post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onTogglePublish;

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
          if (post.coverImageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                post.coverImageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.white.withValues(alpha: 0.04),
                  child: const Icon(Icons.image_not_supported_rounded, color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        post.title,
                        style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (post.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB44C).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Featured',
                          style: GoogleFonts.manrope(color: const Color(0xFFFFB44C), fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    const SizedBox(width: 6),
                    AdminStateChip(state: post.isPublished ? AdminItemState.live : AdminItemState.draft),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  post.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(color: Colors.white60, fontSize: 12.5, height: 1.5),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...post.tags.take(3).map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '#$tag',
                              style: GoogleFonts.manrope(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${post.readingTimeMinutes} min read',
                        style: GoogleFonts.manrope(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w600),
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
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded, color: Colors.white54, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF7C7C), size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
