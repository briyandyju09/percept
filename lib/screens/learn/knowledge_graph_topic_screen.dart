import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/content/knowledge_graph_data.dart';
import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/section_header.dart';

/// Idea.txt's "Knowledge Graph" — Topic -> Books -> Research -> Experts ->
/// Lessons -> Exercises -> Scenarios -> Reflection, as one browsable
/// reference screen per discipline.
class KnowledgeGraphTopicScreen extends ConsumerWidget {
  const KnowledgeGraphTopicScreen({super.key, required this.disciplineId});

  final String disciplineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discipline = Discipline.byId(disciplineId);
    final entry = kKnowledgeGraph[disciplineId];
    final content = ref.read(contentRepositoryProvider);
    final lessonCount = content.lessonsFor(disciplineId).length;
    final drillCount = content.drillsFor(disciplineId).length;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(middle: Text('${discipline.name} Library')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
          children: [
            const SectionHeader('Books'),
            for (final book in entry?.books ?? []) _bullet(context, book),
            const SectionHeader('Experts & Thinkers'),
            for (final expert in entry?.experts ?? []) _bullet(context, expert),
            const SectionHeader('Research Areas'),
            for (final area in entry?.researchAreas ?? []) _bullet(context, area),
            const SectionHeader('In Percept'),
            GestureDetector(
              onTap: () => context.push(
                RoutePaths.withParam(RoutePaths.learnDisciplineDetail, 'disciplineId', disciplineId),
              ),
              child: _row(context, '🧠', '$lessonCount lessons'),
            ),
            GestureDetector(
              onTap: () => context.push(
                RoutePaths.withParam(RoutePaths.practiceLab, 'labCategory', discipline.labName),
              ),
              child: _row(context, '👁', '$drillCount practice drills'),
            ),
            const SizedBox(height: PerceptSpacing.md),
            Container(
              padding: const EdgeInsets.all(PerceptSpacing.lg),
              decoration: BoxDecoration(
                color: context.perceptSurfaceRaised,
                borderRadius: BorderRadius.circular(PerceptRadii.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('REFLECT', style: PerceptTypography.caption(context.perceptPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    'Where has ${discipline.name.toLowerCase()} shown up in your life this week?',
                    style: PerceptTypography.body(context.textPrimary, serif: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('· ', style: PerceptTypography.body(context.textSecondary)),
        Expanded(child: Text(text, style: PerceptTypography.body(context.textPrimary))),
      ],
    ),
  );

  Widget _row(BuildContext context, String glyph, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.sm),
    child: Row(
      children: [
        Text(glyph, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: PerceptSpacing.md),
        Text(text, style: PerceptTypography.bodyEmphasis(context.perceptPrimary)),
        const Spacer(),
        Icon(CupertinoIcons.chevron_forward, size: 16, color: context.textTertiary),
      ],
    ),
  );
}
