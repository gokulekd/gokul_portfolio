import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// True when the browser supports the Web Share API (`navigator.share`),
/// which mobile Chrome and Safari do.
bool get hasNativeShare {
  final navigator = globalContext['navigator'] as JSObject?;
  return navigator != null && navigator.has('share');
}
