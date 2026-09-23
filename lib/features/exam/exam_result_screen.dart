import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'exam_session.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen({super.key, required this.session});

  final ExamSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final passed = session.passed;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.examResultTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                passed ? Icons.check_circle : Icons.cancel,
                color: passed ? AppTheme.correct : AppTheme.incorrect,
                size: 72,
              ),
              const SizedBox(height: 16),
              Text(
                passed ? l10n.examPassed : l10n.examFailed,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${session.correctCount}',
                      style: const TextStyle(
                        color: AppTheme.correct,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' ${l10n.examCorrectLabel} · '),
                    TextSpan(
                      text: '${session.wrongCount}',
                      style: const TextStyle(
                        color: AppTheme.incorrect,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' ${l10n.examWrongLabel}'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                child: Text(l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
