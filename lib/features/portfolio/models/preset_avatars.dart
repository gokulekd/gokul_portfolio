import '../../../core/services/supabase_storage_service.dart';

/// "Don't want to upload a photo? Pick one" avatars shown on the public
/// testimonial submission page. Hosted once in Supabase Storage
/// (`media/testimonials/presets/`, uploaded out-of-band — not through the
/// app) rather than bundled as Flutter assets, so picking one just drops a
/// plain public HTTPS URL into `TestimonialEntry.avatarUrl` — the exact same
/// shape as an uploaded photo, no special-casing needed anywhere
/// testimonials are displayed.
class PresetAvatar {
  const PresetAvatar({required this.id, required this.fileName});

  final String id;
  final String fileName;

  String get url => SupabaseStorageService().getPublicUrl(
        SupabaseStorageService.mediaBucket,
        'testimonials/presets/$fileName',
      ) ??
      '';
}

const List<PresetAvatar> presetAvatars = [
  PresetAvatar(id: 'ceo1', fileName: 'ceo1.jpg'),
  PresetAvatar(id: 'ceo2', fileName: 'ceo2.jpg'),
  PresetAvatar(id: 'ceo3', fileName: 'ceo3.jpg'),
  PresetAvatar(id: 'female1', fileName: 'female1.jpg'),
  PresetAvatar(id: 'female2', fileName: 'female2.jpg'),
  PresetAvatar(id: 'female3', fileName: 'female3.jpg'),
  PresetAvatar(id: 'male1', fileName: 'male1.jpg'),
  PresetAvatar(id: 'male2', fileName: 'male2.jpg'),
  PresetAvatar(id: 'male3', fileName: 'male3.jpg'),
];
