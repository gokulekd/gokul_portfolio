import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/supabase/supabase_bootstrap.dart';

class SupabaseStorageService {
  static const String mediaBucket = 'media';
  static const String resumesBucket = 'resumes';

  bool get isEnabled => SupabaseBootstrap.isReady;

  SupabaseClient get _client => SupabaseBootstrap.client;

  /// Uploads bytes to a Supabase Storage bucket and returns the public URL.
  /// Returns null if Supabase is not configured or upload fails.
  Future<String?> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String contentType = 'application/octet-stream',
  }) async {
    if (!isEnabled) return null;
    try {
      await _client.storage.from(bucket).uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(contentType: contentType, upsert: true),
      );
      return _client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      // ignore: avoid_print
      print('[SupabaseStorage] uploadFile failed — bucket: $bucket, path: $path, error: $e');
      return null;
    }
  }

  Future<bool> deleteFile({
    required String bucket,
    required String path,
  }) async {
    if (!isEnabled) return false;
    try {
      await _client.storage.from(bucket).remove([path]);
      return true;
    } catch (_) {
      return false;
    }
  }

  String? getPublicUrl(String bucket, String path) {
    if (!isEnabled) return null;
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  /// Convenience helper: generates a timestamped path and uploads.
  Future<UploadResult?> uploadFromBytes({
    required String bucket,
    required String folder,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final ext = fileName.contains('.') ? fileName.split('.').last : '';
    final contentType = _contentTypeFromExtension(ext);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final path = '$folder/${timestamp}_$safeName';
    final url = await uploadFile(
      bucket: bucket,
      path: path,
      bytes: bytes,
      contentType: contentType,
    );
    if (url == null) return null;
    return UploadResult(url: url, path: path);
  }

  String _contentTypeFromExtension(String ext) => switch (ext.toLowerCase()) {
    'jpg' || 'jpeg' => 'image/jpeg',
    'png' => 'image/png',
    'gif' => 'image/gif',
    'webp' => 'image/webp',
    'svg' => 'image/svg+xml',
    'pdf' => 'application/pdf',
    'doc' => 'application/msword',
    'docx' =>
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    _ => 'application/octet-stream',
  };
}

class UploadResult {
  const UploadResult({required this.url, required this.path});
  final String url;
  final String path;
}
