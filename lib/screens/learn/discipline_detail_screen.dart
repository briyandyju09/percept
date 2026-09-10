import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/percept_card.dart';
import '../../widgets/section_header.dart';

class DisciplineDetailScreen extends ConsumerWidget {
  const DisciplineDetailScreen({super.key, required this.disciplineId});

  final String disciplineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discipline = Discipline.byId(disciplineId);
    final content = ref.read(contentRepositoryProvider);
    final lessons = content.lessonsFor(disciplineId);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(middle: Text(discipline.name)),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: PerceptSpacing.screenMargin,
          ),
          children: [
            const SizedBox(height: PerceptSpacing.sm),
            Text(discipline.tagline, style: PerceptTypography.subhead(context.textSecondary)),
            const SizedBox(height: PerceptSpacing.sm),
            GestureDetector(
              onTap: () => context.push(
                RoutePaths.withParam(RoutePaths.libraryDiscipline, 'disciplineId', disciplineId),
              ),
              child: Row(
                children: [
                  const Text('📚', style: TextStyle(fontSize: PerceptGlyphSize.inline)),
                  const SizedBox(width: PerceptSpacing.sm),
                  Text(
                    'Browse the library',
                    style: PerceptTypography.subhead(context.perceptPrimary),
                  ),
                ],
              ),
            ),
            const SectionHeader('Lessons'),
            for (final lesson in lessons)
              PerceptCard(
                margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                onTap: () => context.push(
                  RoutePaths.withParam(RoutePaths.learnLesson, 'lessonId', lesson.id),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lesson.title, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
                          const SizedBox(height: 2),
                          Text(
                            lesson.hook,
                            style: PerceptTypography.footnote(context.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: PerceptSpacing.xs),
                          PerceptMetaLine(['${lesson.estimatedMinutes} min', lesson.mode.name]),
                        ],
                      ),
                    ),
                    if (ref.watch(isLessonCompletedProvider(lesson.id)))
                      Icon(CupertinoIcons.check_mark_circled_solid, color: context.perceptPrimary)
                    else
                      Icon(CupertinoIcons.chevron_forward, color: context.textTertiary, size: 18),
                  ],
                ),
              ),
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
