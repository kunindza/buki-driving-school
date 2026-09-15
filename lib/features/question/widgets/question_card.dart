import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../data/models/localized_text.dart';
import '../../../data/models/question.dart';

/// Displays one question: image (or placeholder), text, answer options and,
/// once answered, correct/incorrect feedback plus an explanation toggle.
/// Shared by "By Subject", "All Questions" and the exam so answer feedback
/// looks identical everywhere.
///
/// Renders two option styles: a plain centered button for yes/no questions
/// (exactly 2 options), and a numbered left-aligned row for multiple-choice
/// questions (3+ options).
class QuestionCard extends StatefulWidget {
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
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _showExplanation = false;

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _showExplanation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;
    final answered = widget.selectedOptionIndex != null;
    final numbered = question.options.length > 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _QuestionImage(imagePath: question.image),
          const SizedBox(height: 16),
          Text(
            question.text.resolve(widget.languageCode),
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < question.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionButton(
                label: question.options[i].resolve(widget.languageCode),
                number: numbered ? i + 1 : null,
                state: _stateFor(i, question),
                onTap: answered ? null : () => widget.onOptionSelected(i),
              ),
            ),
          if (answered && question.explanation != null) ...[
            const SizedBox(height: 4),
            Center(
              child: _InfoButton(
                active: _showExplanation,
                onTap: () =>
                    setState(() => _showExplanation = !_showExplanation),
              ),
            ),
            if (_showExplanation)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  question.explanation!.resolve(widget.languageCode),
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
              ),
          ],
        ],
      ),
    );
  }

  _OptionState _stateFor(int index, Question question) {
    final selected = widget.selectedOptionIndex;
    if (selected == null) return _OptionState.neutral;
    if (index == question.correctIndex) return _OptionState.correct;
    if (index == selected) return _OptionState.incorrect;
    return _OptionState.neutral;
  }
}

class _QuestionImage extends StatelessWidget {
  const _QuestionImage({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppTheme.radius),
      ),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: imagePath == null
            ? Container(
                color: AppTheme.surface,
                child: const Icon(
                  Icons.directions_car_filled_outlined,
                  size: 48,
                  color: Colors.white38,
                ),
              )
            : Image.asset(
                'assets/images/questions/$imagePath',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _InfoButton extends StatelessWidget {
  const _InfoButton({required this.active, required this.onTap});

  final bool active;
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
