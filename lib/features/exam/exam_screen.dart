import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets/brand_mark.dart';
import '../../l10n/app_localizations.dart';
import '../question/widgets/question_card.dart';
import 'exam_config.dart';
import 'exam_result_screen.dart';
import 'exam_session.dart';

class ExamScreen extends ConsumerStatefulWidget {
  const ExamScreen({
    super.key,
    required this.category,
    required this.languageCode,
  });

  final String category;
  final String languageCode;

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen> {
  ExamSession? _session;
  int _index = 0;
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = const Duration(minutes: ExamConfig.durationMinutes);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimerOnce() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining -= const Duration(seconds: 1);
        if (_remaining <= Duration.zero) {
          _remaining = Duration.zero;
          _finish();
        }
      });
    });
  }

  void _finish() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ExamResultScreen(session: _session!)),
    );
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repoAsync = ref.watch(questionRepositoryProvider);

    return Scaffold(
      body: SafeArea(
        child: repoAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('$err')),
          data: (repo) {
            _session ??= ExamSession(
              repo.randomExamSet(widget.category, ExamConfig.questionCount),
            );
            final session = _session!;

            if (session.questions.isEmpty) {
              return Center(child: Text(l10n.noQuestionsYet));
            }

            _startTimerOnce();
            final question = session.questions[_index];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Row(
                    children: [
                      _StatBox(
                        value: _formatTime(_remaining),
                        color: AppTheme.amber,
                        icon: Icons.timer_rounded,
                      ),
                      const SizedBox(width: 6),
                      _StatBox(
                        value: '${_index + 1}(${session.questions.length})',
                        color: Colors.white12,
                        dark: true,
                      ),
                      const SizedBox(width: 6),
                      _StatBox(
                        value: '${session.correctCount}',
                        color: AppTheme.correct,
                        icon: Icons.check_rounded,
                      ),
                      const SizedBox(width: 6),
                      _StatBox(
                        value: '${session.wrongCount}',
                        color: AppTheme.incorrect,
                        icon: Icons.close_rounded,
                      ),
                      const Spacer(),
                      const BrandMark(size: 30),
                    ],
                  ),
                ),
                Expanded(
                  child: QuestionCard(
                    key: ValueKey(question.id),
                    question: question,
                    languageCode: widget.languageCode,
                    selectedOptionIndex: session.answerFor(_index),
                    onOptionSelected: (option) =>
                        setState(() => session.answer(_index, option)),
                  ),
                ),
                _PageStrip(
                  count: session.questions.length,
                  current: _index,
                  onPrevious: _index > 0
                      ? () => setState(() => _index--)
                      : null,
                  onNext: _index < session.questions.length - 1
                      ? () => setState(() => _index++)
                      : null,
                  onJump: (i) => setState(() => _index = i),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: session.isComplete ? _finish : null,
                      child: Text(l10n.examSubmit),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.value,
    required this.color,
    this.icon,
    this.dark = false,
  });

  final String value;
  final Color color;
  final IconData? icon;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? Colors.white : Colors.black87;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageStrip extends StatelessWidget {
  const _PageStrip({
    required this.count,
    required this.current,
    required this.onPrevious,
    required this.onNext,
    required this.onJump,
  });

  final int count;
  final int current;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count,
              itemBuilder: (context, i) {
                final selected = i == current;
                return InkWell(
                  onTap: () => onJump(i),
                  child: Container(
                    width: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected
                              ? AppTheme.brandPink
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white54,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }
}
