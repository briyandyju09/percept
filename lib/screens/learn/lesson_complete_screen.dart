import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/dimension_scores.dart';
import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class LessonCompleteScreen extends ConsumerStatefulWidget {
  const LessonCompleteScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends ConsumerState<LessonCompleteScreen> {
  bool _recorded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final lesson = ref.read(contentRepositoryProvider).lessonById(widget.lessonId);
      if (lesson != null) {
        await ref.read(practiceActionsProvider).completeLesson(lesson);
        if (mounted) setState(() => _recorded = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = ref.read(contentRepositoryProvider).lessonById(widget.lessonId);
    if (lesson == null) return const SizedBox.shrink();
    final discipline = Discipline.byId(lesson.disciplineId);
    final relatedDrillId = lesson.relatedDrillIds.isNotEmpty ? lesson.relatedDrillIds.first : null;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
          child: Column(
            children: [
              const Spacer(),
              const Text('✓', style: TextStyle(fontSize: PerceptGlyphSize.hero)),
              const SizedBox(height: PerceptSpacing.lg),
              Text('Lesson complete', style: PerceptTypography.title1(context.textPrimary)),
              const SizedBox(height: PerceptSpacing.sm),
              Text(
                _recorded
                    ? '+1 ${DimensionMeta.labels[discipline.primaryDimension] ?? discipline.primaryDimension}'
                    : 'Saving…',
                style: PerceptTypography.bodyEmphasis(context.perceptPrimary),
              ),
              const Spacer(),
              if (relatedDrillId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: () => context.pushReplacement(
                        RoutePaths.withParam(RoutePaths.practiceDrill, 'drillId', relatedDrillId),
                      ),
                      child: const Text('Try the related drill'),
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  onPressed: () {
                    while (context.canPop()) {
                      context.pop();
                    }
                  },
                  child: const Text('Back to Learn'),
                ),
              ),
              const SizedBox(height: PerceptSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
