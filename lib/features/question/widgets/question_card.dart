import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../data/models/localized_text.dart';
import '../../../data/models/question.dart';

/// Displays one question: photo (when it has one), text, answer options and,
/// once answered, correct/incorrect feedback plus a button that opens the
/// explanation in a dialog. Shared by "By Subject", "All Questions" and the
/// exam so answer feedback looks identical everywhere.
///
/// Renders two option styles: a plain centered button for yes/no questions
/// (exactly 2 options), and a numbered left-aligned row for multiple-choice
/// questions (3+ options).
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.languageCode,
    required this.selectedOptionIndex,
    required this.onOptionSelected,
  });

  final Question question;
  final String languageCode;

  /// Null if the user hasn't answered this question yet.
  final int? selectedOptionIndex;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final answered = selectedOptionIndex != null;
    final numbered = question.options.length > 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Roughly half the real ticket bank is text-only (legal/procedural
          // questions with no photo). Skip the image slot entirely for
          // those rather than showing an empty box that reads as broken.
          if (question.image != null) ...[
            _QuestionImage(
              imagePath: question.image!,
              answerMediaPath: question.answerMedia,
              answered: answered,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            question.text.resolve(languageCode),
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < question.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionButton(
                label: question.options[i].resolve(languageCode),
                number: numbered ? i + 1 : null,
                state: _stateFor(i),
                onTap: answered ? null : () => onOptionSelected(i),
              ),
            ),
          if (answered && question.explanation != null) ...[
            const SizedBox(height: 4),
            Center(
              child: _InfoButton(
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => _ExplanationDialog(
                    text: question.explanation!.resolve(languageCode),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _OptionState _stateFor(int index) {
    final selected = selectedOptionIndex;
    if (selected == null) return _OptionState.neutral;
    if (index == question.correctIndex) return _OptionState.correct;
    if (index == selected) return _OptionState.incorrect;
    return _OptionState.neutral;
  }
}

/// Shown only when the question has a photo — text-only questions skip
/// this widget entirely (see [QuestionCard.build]).
class _QuestionImage extends StatelessWidget {
  const _QuestionImage({
    required this.imagePath,
    required this.answerMediaPath,
    required this.answered,
  });

  final String imagePath;

  /// Animated clip (arrows recolored to the correct path) shown in place of
  /// the static photo once the question has been answered, when available.
  final String? answerMediaPath;
  final bool answered;

  @override
  Widget build(BuildContext context) {
    final showAnswerMedia = answered && answerMediaPath != null;
    final path = showAnswerMedia
        ? 'assets/images/answers/$answerMediaPath'
        : 'assets/images/questions/$imagePath';

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppTheme.radius),
      ),
      // Matches the real ticket photos' native aspect ratio (700x323).
      child: AspectRatio(
        aspectRatio: 700 / 323,
        child: Image.asset(path, fit: BoxFit.cover, gaplessPlayback: true),
      ),
    );
  }
}

class _InfoButton extends StatelessWidget {
  const _InfoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.amber,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.info_outline, color: Colors.black87, size: 22),
        ),
      ),
    );
  }
}

/// The explanation, shown as a centered dialog over a dimmed background
/// instead of expanding inline — so it's always fully visible without
/// scrolling, regardless of how much is above it on the question screen.
class _ExplanationDialog extends StatelessWidget {
  const _ExplanationDialog({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppTheme.amber,
                    size: 22,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.close, color: Colors.white54, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _OptionState { neutral, correct, incorrect }

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.number,
    required this.state,
    required this.onTap,
  });

  final String label;
  final int? number;
  final _OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = switch (state) {
      _OptionState.correct => AppTheme.correct,
      _OptionState.incorrect => AppTheme.incorrect,
      _OptionState.neutral => AppTheme.surface,
    };

    final content = number == null
        ? Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        : Row(
            children: [
              _NumberBadge(number: number!, state: state),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          );

    // Once a question is answered every option becomes non-interactive, but
    // it must still render at full color — Material's disabled-button state
    // fades backgroundColor, which would wash out the correct/incorrect
    // feedback. So the button stays "enabled" and taps are absorbed instead.
    return IgnorePointer(
      ignoring: onTap == null,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: state == _OptionState.neutral
                  ? Border.all(color: AppTheme.divider)
                  : null,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.state});

  final int number;
  final _OptionState state;

  @override
  Widget build(BuildContext context) {
    final badgeColor = state == _OptionState.neutral
        ? AppTheme.brandPink.withValues(alpha: 0.22)
        : Colors.black.withValues(alpha: 0.2);
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
