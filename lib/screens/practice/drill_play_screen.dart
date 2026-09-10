import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/drill.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../utils/gradable_text.dart';
import '../../widgets/timer_ring.dart';

enum _Phase { study, questions }

/// A single configurable engine that plays any [Drill], branching its
/// layout by [DrillType] rather than having 6 near-duplicate screens:
/// - `observationSprint`/`recallQuiz` with a stimulus: timed study phase,
///   then the stimulus hides and recall questions follow.
/// - `breathingTimer`: a timed breathing ring, then a reflection prompt.
/// - `timedPressure`: an overall countdown ring runs alongside a rapid
///   sequence of quick questions.
/// - `multipleChoice`/`freeTextScenario` (no stimulus): straight to
///   questions.
class DrillPlayScreen extends ConsumerStatefulWidget {
  const DrillPlayScreen({super.key, required this.drillId});

  final String drillId;

  @override
  ConsumerState<DrillPlayScreen> createState() => _DrillPlayScreenState();
}

class _DrillPlayScreenState extends ConsumerState<DrillPlayScreen> {
  late _Phase _phase;
  int _questionIndex = 0;
  final Map<String, dynamic> _answers = {};
  dynamic _currentDraft;
  bool _timeUp = false;

  Drill get _drill => ref.read(contentRepositoryProvider).drillById(widget.drillId)!;

  @override
  void initState() {
    super.initState();
    final drill = _drill;
    final hasStudyPhase = drill.type == DrillType.breathingTimer ||
        ((drill.type == DrillType.observationSprint || drill.type == DrillType.recallQuiz) &&
            (drill.stimulusText?.isNotEmpty ?? false));
    _phase = hasStudyPhase ? _Phase.study : _Phase.questions;
  }

  bool _gradeAnswer(dynamic question, dynamic answer) {
    final correct = question.correctAnswer;
    if (correct == null) return true;
    final text = (answer ?? '').toString().trim();

    if (question.type == 'textInput') {
      final correctText = correct.toString().trim();
      // A long/hedged correctAnswer means this is genuinely open-ended
      // (a reflection, not a quiz question with one right answer) —
      // credit any substantive attempt. A short, literal correctAnswer
      // means there IS a real answer to get right, so grade it via
      // lenient token-overlap matching instead of word-counting.
      final isOpenReflection =
          looksHedgy(correctText) || wordCount(correctText) > 5;
      if (isOpenReflection) {
        return wordCount(text) >= 3;
      }
      return text.isNotEmpty && tokenOverlapMatches(text, correctText);
    }

    final a = text.toLowerCase();
    final c = correct.toString().trim().toLowerCase();
    return a.isNotEmpty && a == c;
  }

  void _finish() {
    final drill = _drill;
    var correct = 0;
    for (final q in drill.questions) {
      if (_gradeAnswer(q, _answers[q.id])) correct++;
    }
    final total = drill.questions.isEmpty ? 1 : drill.questions.length;
    final percent = ((correct / total) * 100).round();
    ref.read(practiceActionsProvider).completeDrill(drill, scorePercent: percent);
    context.pushReplacement(
      RoutePaths.withParam(RoutePaths.practiceDrillResult, 'drillId', widget.drillId),
      extra: {'correctCount': correct, 'totalCount': total},
    );
  }

  void _nextQuestion() {
    final drill = _drill;
    if (drill.questions.isNotEmpty) {
      _answers[drill.questions[_questionIndex].id] = _currentDraft;
    }
    _currentDraft = null;
    if (_questionIndex < drill.questions.length - 1 && !_timeUp) {
      setState(() => _questionIndex++);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final drill = _drill;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(middle: Text(drill.labCategory)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
          child: _phase == _Phase.study
              ? _buildStudy(context, drill)
              : _buildQuestions(context, drill),
        ),
      ),
    );
  }

  Widget _buildStudy(BuildContext context, Drill drill) {
    final isBreathing = drill.type == DrillType.breathingTimer;
    return Column(
      children: [
        Text(
          drill.prompt,
          style: PerceptTypography.title3(context.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PerceptSpacing.xl),
        if (!isBreathing && drill.stimulusText != null) ...[
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                drill.stimulusText!,
                style: PerceptTypography.body(context.textPrimary, serif: true),
              ),
            ),
          ),
          const SizedBox(height: PerceptSpacing.lg),
        ] else
          const Spacer(),
        TimerRing(
          totalSeconds: isBreathing ? drill.stimulusSeconds : drill.stimulusSeconds,
          onComplete: () => setState(() => _phase = _Phase.questions),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildQuestions(BuildContext context, Drill drill) {
    if (drill.questions.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _finish());
      return const Center(child: CupertinoActivityIndicator());
    }
    final q = drill.questions[_questionIndex];
    final showTimer = drill.type == DrillType.timedPressure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Question ${_questionIndex + 1} of ${drill.questions.length}',
                style: PerceptTypography.caption(context.perceptPrimary),
              ),
            ),
            if (showTimer)
              SizedBox(
                width: 36,
                height: 36,
                child: TimerRing(
                  size: 36,
                  totalSeconds: drill.estimatedMinutes * 60,
                  onComplete: () {
                    _timeUp = true;
                    _finish();
                  },
                ),
              ),
          ],
        ),
        const SizedBox(height: PerceptSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(q.prompt, style: PerceptTypography.title3(context.textPrimary)),
                const SizedBox(height: PerceptSpacing.lg),
                _answerControl(context, q),
              ],
            ),
          ),
        ),
        const SizedBox(height: PerceptSpacing.md),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton.filled(
            onPressed: _nextQuestion,
            child: Text(_questionIndex < drill.questions.length - 1 ? 'Next' : 'Finish'),
          ),
        ),
      ],
    );
  }

  Widget _answerControl(BuildContext context, dynamic q) {
    if (q.type == 'multipleChoice' || q.type == 'trueFalse') {
      final options = (q.options as List).cast<String>();
      return Column(
        children: [
          for (final option in options)
            Padding(
              padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
              child: GestureDetector(
                onTap: () => setState(() => _currentDraft = option),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: _currentDraft == option
                        ? context.perceptPrimary.withValues(alpha: 0.1)
                        : context.perceptSurface,
                    borderRadius: BorderRadius.circular(PerceptRadii.card),
                    border: Border.all(
                      color: _currentDraft == option
                          ? context.perceptPrimary
                          : context.perceptHairline,
                    ),
                  ),
                  child: Text(option, style: PerceptTypography.body(context.textPrimary)),
                ),
              ),
            ),
        ],
      );
    }
    return CupertinoTextField(
      placeholder: q.type == 'numericInput' ? 'Enter a number…' : 'Type your answer…',
      keyboardType: q.type == 'numericInput' ? TextInputType.number : TextInputType.multiline,
      maxLines: q.type == 'numericInput' ? 1 : 4,
      padding: const EdgeInsets.all(PerceptSpacing.md),
      decoration: BoxDecoration(
        color: context.perceptSurface,
        borderRadius: BorderRadius.circular(PerceptRadii.card),
        border: Border.all(color: context.perceptHairline),
      ),
      onChanged: (v) => _currentDraft = v,
    );
  }
}
