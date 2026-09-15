import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets/brand_mark.dart';
import '../../data/models/localized_text.dart';
import '../question/question_flow_screen.dart';

class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({
    super.key,
    required this.category,
    required this.languageCode,
  });

  final String category;
  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoAsync = ref.watch(questionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const BrandMark()),
      body: repoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('$err')),
        data: (repo) {
          final subjects = repo.subjects;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: subjects.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 68),
            itemBuilder: (context, i) {
              final subject = subjects[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: _IndexBadge(number: i + 1),
                title: Text(
                  subject.title.resolve(languageCode),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white38,
                ),
                onTap: () {
                  final questions = repo.questionsForSubject(
                    category,
                    subject.id,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuestionFlowScreen(
                        questions: questions,
                        languageCode: languageCode,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.brandPink.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: AppTheme.brandPink,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
