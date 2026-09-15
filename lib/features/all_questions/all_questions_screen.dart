import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/widgets/brand_mark.dart';
import '../question/question_flow_screen.dart';

class AllQuestionsScreen extends ConsumerWidget {
  const AllQuestionsScreen({
    super.key,
    required this.category,
    required this.languageCode,
  });

  final String category;
  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoAsync = ref.watch(questionRepositoryProvider);

    return repoAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const BrandMark()),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const BrandMark()),
        body: Center(child: Text('$err')),
      ),
      data: (repo) => QuestionFlowScreen(
        questions: repo.questionsForCategory(category),
        languageCode: languageCode,
      ),
    );
  }
}
