import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/models/app_language.dart';
import '../../l10n/app_localizations.dart';
import '../all_questions/all_questions_screen.dart';
import '../exam/exam_screen.dart';
import '../subjects/subjects_screen.dart';

/// The landing screen. On every cold start it first gates on a language
/// choice (three flags) before revealing the category stepper and the
/// three study-mode buttons.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _languagePicked = false;

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final category = ref.watch(categoryProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _BrandBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _languagePicked
                    ? _HomeContent(
                        key: const ValueKey('home'),
                        language: language,
                        category: category,
                      )
                    : _LanguageGate(
                        key: const ValueKey('gate'),
                        onPicked: (picked) {
                          ref.read(languageProvider.notifier).select(picked);
                          setState(() => _languagePicked = true);
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-bleed background behind the whole landing screen — the school's
/// own logo, dimmed with a dark scrim so the text on top stays legible.
class _BrandBackground extends StatelessWidget {
  const _BrandBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.black),
        Image.asset(
          'assets/brand/logo.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => const Center(
            child: Icon(
              Icons.directions_car_filled,
              size: 96,
              color: Colors.white24,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.72),
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
        ),
      ],
    );
  }
}

/// The first thing shown on every cold start: pick one of the three
/// languages before anything else on the landing page becomes available.
class _LanguageGate extends StatelessWidget {
  const _LanguageGate({super.key, required this.onPicked});

  final ValueChanged<AppLanguage> onPicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.language_rounded, color: Colors.white70, size: 30),
        const SizedBox(height: 14),
        Text(
          AppLanguage.values.map((l) => l.label).join('  ·  '),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 28),
        for (final language in AppLanguage.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _GlassButton(
              onTap: () => onPicked(language),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    language.flagEmoji,
                    style: const TextStyle(fontSize: 26),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    language.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    super.key,
    required this.language,
    required this.category,
  });

  final AppLanguage language;
  final String category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: _LanguageDropdown(current: language),
        ),
        const Spacer(flex: 3),
        Text(
          l10n.appTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black87, blurRadius: 12)],
          ),
        ),
        const Spacer(flex: 2),
        _CategoryStepper(category: category),
        const Spacer(flex: 3),
        _PillButton(
          icon: Icons.menu_book_rounded,
          label: l10n.bySubject,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SubjectsScreen(
                category: category,
                languageCode: language.code,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _PillButton(
          icon: Icons.view_list_rounded,
          label: l10n.allQuestions,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AllQuestionsScreen(
                category: category,
                languageCode: language.code,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _PillButton(
          icon: Icons.timer_rounded,
          label: l10n.exam,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  ExamScreen(category: category, languageCode: language.code),
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

/// A frosted-glass chip: blurs the busy logo background behind it so text
/// and controls stay legible without hiding the brand image entirely.
class _GlassChip extends StatelessWidget {
  const _GlassChip({
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(12),
    this.borderColor,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.14),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Material(
            color: Colors.white.withValues(alpha: 0.07),
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(
                    color: AppTheme.brandPink.withValues(alpha: 0.55),
                  ),
                ),
                alignment: Alignment.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageDropdown extends ConsumerWidget {
  const _LanguageDropdown({required this.current});

  final AppLanguage current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<AppLanguage>(
      initialValue: current,
      onSelected: (language) =>
          ref.read(languageProvider.notifier).select(language),
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppTheme.divider),
      ),
      itemBuilder: (context) => AppLanguage.values
          .map(
            (language) => PopupMenuItem(
              value: language,
              child: Row(
                children: [
                  Text(
                    language.flagEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    language.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: _GlassChip(
        borderRadius: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(current.flagEmoji, style: const TextStyle(fontSize: 20)),
            const Icon(
              Icons.expand_more_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryStepper extends ConsumerWidget {
  const _CategoryStepper({required this.category});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(categoryProvider.notifier);
    return _GlassChip(
      borderRadius: 20,
      borderColor: AppTheme.brandPink.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepArrow(
            icon: Icons.chevron_left_rounded,
            onTap: () => notifier.step(-1),
          ),
          SizedBox(
            width: 84,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_vehicleIconFor(category), color: Colors.white, size: 34),
                const SizedBox(height: 6),
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _StepArrow(
            icon: Icons.chevron_right_rounded,
            onTap: () => notifier.step(1),
          ),
        ],
      ),
    );
  }
}

/// The category stepper's icon changes with the selected category so it
/// actually depicts the vehicle type, not just a generic car.
IconData _vehicleIconFor(String category) => switch (category) {
  'AM' => Icons.moped_rounded,
  'A1' || 'A' => Icons.two_wheeler_rounded,
  'C1' || 'C' => Icons.local_shipping_rounded,
  'D1' || 'D' => Icons.directions_bus_filled_rounded,
  _ => Icons.directions_car_filled_rounded, // B1, B
};

class _StepArrow extends StatelessWidget {
  const _StepArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      icon: Icon(icon, color: AppTheme.brandPink, size: 24),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _GlassButton(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.brandPink, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.brandPink,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
