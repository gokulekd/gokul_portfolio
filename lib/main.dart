import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/firebase/firebase_bootstrap.dart';
import 'core/supabase/supabase_bootstrap.dart';
import 'providers/theme_provider.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  await SupabaseBootstrap.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final textTheme = GoogleFonts.manropeTextTheme();

    return MaterialApp.router(
      title: 'Gokul K S — Flutter Developer & Designer',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(textTheme),
      darkTheme: buildDarkTheme(textTheme),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
