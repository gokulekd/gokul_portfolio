/// Whether the platform has a native share sheet.
///
/// On the web, share_plus falls back to opening a `mailto:` link when the
/// browser lacks the Web Share API (most desktop browsers), so callers check
/// this first and copy the link instead.
library;

export 'native_share_stub.dart'
    if (dart.library.js_interop) 'native_share_web.dart';
