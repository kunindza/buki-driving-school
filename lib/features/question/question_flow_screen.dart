import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../app/widgets/brand_mark.dart';
import '../../data/models/question.dart';
import '../../l10n/app_localizations.dart';
import 'image_prefetch.dart';
import 'widgets/question_card.dart';

/// Sequential question browser shared by "By Subject" and "All Questions" —
/// the two modes differ only in which [questions] list they pass in.
class QuestionFlowScreen extends StatefulWidget {
  const QuestionFlowScreen({
    super.key,
    required this.questions,
    required this.languageCode,
  });

  final List<Question> questions;
  final String languageCode;

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  int _index = 0;
  final Map<int, int> _answers = {};

  int get _correctCount => _answers.entries
      .where((e) => widget.questions[e.key].correctIndex == e.value)
      .length;

  int get _wrongCount => _answers.length - _correctCount;

  /// Warms the cache for the adjacent questions' photos so tapping
  /// next/previous doesn't wait on a fresh network fetch on the web build.
  void _prefetchNeighbors() {
    for (final i in [_index - 1, _index + 1]) {
      if (i >= 0 && i < widget.questions.length) {
        precacheQuestionImage(context, widget.questions[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const BrandMark()),
        body: Center(child: Text(l10n.noQuestionsYet)),
      );
    }

    final question = widget.questions[_index];
    _prefetchNeighbors();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            Text(
              l10n.questionCounter(_index + 1, widget.questions.length),
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const Spacer(),
            const BrandMark(size: 28),
            const Spacer(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$_correctCount',
                    style: const TextStyle(
                      color: AppTheme.correct,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text: '$_wrongCount',
                    style: const TextStyle(
                      color: AppTheme.incorrect,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: QuestionCard(
        key: ValueKey(question.id),
        question: question,
        languageCode: widget.languageCode,
        selectedOptionIndex: _answers[_index],
        onOptionSelected: (option) => setState(() => _answers[_index] = option),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.divider)),
          ),
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: _index > 0 ? () => setState(() => _index--) : null,
                icon: const Icon(Icons.chevron_left),
                iconSize: 30,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: _index < widget.questions.length - 1
                        ? () => setState(() => _index++)
                        : null,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: Text(l10n.nextQuestion),
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
