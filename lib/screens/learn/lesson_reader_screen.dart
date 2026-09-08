import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/lesson_mode_container.dart';

class LessonReaderScreen extends ConsumerWidget {
  const LessonReaderScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.read(contentRepositoryProvider).lessonById(lessonId);
    if (lesson == null) {
      return const CupertinoPageScaffold(child: Center(child: Text('Lesson not found')));
    }

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(middle: Text(lesson.title)),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
                children: [
                  Text(lesson.hook, style: PerceptTypography.title3(context.textSecondary)),
                  const SizedBox(height: PerceptSpacing.lg),
                  LessonModeContainer(lesson: lesson),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () => context.push(
                    RoutePaths.withParam(RoutePaths.learnLessonComplete, 'lessonId', lessonId),
                  ),
                  child: const Text('Mark as read'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
