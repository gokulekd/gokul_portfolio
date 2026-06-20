import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/config/app_colors.dart';

class BannerUploadZone extends StatelessWidget {
  const BannerUploadZone({
    super.key,
    required this.bannerPreviewUrl,
    required this.iconPreviewUrl,
    required this.isUploading,
    required this.isUploadingIcon,
    required this.onUploadBanner,
    required this.onUploadIcon,
  });

  final String bannerPreviewUrl;
  final String iconPreviewUrl;
  final bool isUploading;
  final bool isUploadingIcon;
  final VoidCallback onUploadBanner;
  final VoidCallback onUploadIcon;

  @override
  Widget build(BuildContext context) {
    final hasBanner = bannerPreviewUrl.isNotEmpty;
    final hasIcon = iconPreviewUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isUploading ? null : onUploadBanner,
          child: Container(
            height: 420,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasBanner
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        bannerPreviewUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            BannerPlaceholder(isUploading: isUploading),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.55),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: UploadChip(
                          label: 'Change banner',
                          isUploading: isUploading,
                        ),
                      ),
                    ],
                  )
                : BannerPlaceholder(isUploading: isUploading),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: isUploadingIcon ? null : onUploadIcon,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D21),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: hasIcon
                          ? Image.network(
                              iconPreviewUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  IconPlaceholder(isUploading: isUploadingIcon),
                            )
                          : IconPlaceholder(isUploading: isUploadingIcon),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isUploadingIcon
                              ? Colors.black54
                              : AppColors.primaryGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0E1114),
                            width: 2,
                          ),
                        ),
                        child: isUploadingIcon
                            ? const Padding(
                                padding: EdgeInsets.all(4),
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.primaryGreen,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt_rounded,
                                size: 11,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Icon',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tap icon to upload · 512 × 512 recommended',
                    style: GoogleFonts.manrope(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({super.key, required this.isUploading});
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isUploading)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
            ),
          )
        else ...[
          Icon(
            Icons.add_photo_alternate_rounded,
            size: 30,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Click to upload banner',
            style: GoogleFonts.manrope(
              color: Colors.white30,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Recommended: 1200 × 630',
            style: GoogleFonts.manrope(
              color: Colors.white.withValues(alpha: 0.2),
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}

class IconPlaceholder extends StatelessWidget {
  const IconPlaceholder({super.key, required this.isUploading});
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isUploading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
              ),
            )
          : Icon(
              Icons.apps_rounded,
              size: 28,
              color: Colors.white.withValues(alpha: 0.2),
            ),
    );
  }
}

class UploadChip extends StatelessWidget {
  const UploadChip({super.key, required this.label, required this.isUploading});
  final String label;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUploading)
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(AppColors.primaryGreen),
              ),
            )
          else
            const Icon(
              Icons.upload_rounded,
              size: 12,
              color: Colors.white70,
            ),
          const SizedBox(width: 6),
          Text(
            isUploading ? 'Uploading…' : label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
