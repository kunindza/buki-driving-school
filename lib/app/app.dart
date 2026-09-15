import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/onboarding/home_screen.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'theme.dart';

class TheoryApp extends ConsumerWidget {
  const TheoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      locale: Locale(language.code),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // This is a phone app. On a wide desktop/web window, pin every screen
      // to a phone-width column instead of stretching content (and photos)
      // across the whole browser — same layout the app uses on an actual
      // phone, just letterboxed on wide screens rather than blown up.
      builder: (context, child) {
        return ColoredBox(
          color: AppTheme.background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child,
            ),
          ),
        );
      },
      home: const HomeScreen(),
    );
  }
}
