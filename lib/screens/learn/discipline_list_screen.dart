import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/content_repository.dart';
import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class DisciplineListScreen extends ConsumerWidget {
  const DisciplineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.read(contentRepositoryProvider);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Disciplines')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
          children: [
            for (final discipline in Discipline.all)
              _DisciplineTile(discipline: discipline, content: content),
          ],
        ),
      ),
    );
  }
}

class _DisciplineTile extends ConsumerWidget {
  const _DisciplineTile({required this.discipline, required this.content});

  final Discipline discipline;
  final ContentRepository content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = content.lessonsFor(discipline.id);
    final completedCount = lessons
        .where((l) => ref.watch(isLessonCompletedProvider(l.id)))
        .length;

    return GestureDetector(
      onTap: () => context.push(
        RoutePaths.withParam(RoutePaths.learnDisciplineDetail, 'disciplineId', discipline.id),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
        padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
        decoration: BoxDecoration(
          color: context.perceptSurface,
          borderRadius: BorderRadius.circular(PerceptRadii.card),
          border: Border.all(color: context.perceptHairline),
        ),
        child: Row(
          children: [
            Text(discipline.icon, style: const TextStyle(fontSize: PerceptGlyphSize.row)),
            const SizedBox(width: PerceptSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(discipline.name, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
                  const SizedBox(height: 2),
                  Text(discipline.tagline, style: PerceptTypography.footnote(context.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    '$completedCount / ${lessons.length} lessons',
                    style: PerceptTypography.caption(context.perceptPrimary),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_forward, color: context.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}
