# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Google Sign-In
-keep class com.google.android.gms.auth.** { *; }

# Keep your app's model classes
-keep class com.example.gokul_portfolio.** { *; }

# Flutter's engine references Play Core (deferred components), which this app
# doesn't use — silence R8's missing-class errors for it.
-dontwarn com.google.android.play.core.**
