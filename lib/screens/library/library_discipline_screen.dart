import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../models/library_resource.dart';
import '../../routing/route_paths.dart';
import '../../state/repository_providers.dart';
import '../../theme/glyphs.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/percept_card.dart';
import '../../widgets/section_header.dart';

class LibraryDisciplineScreen extends ConsumerWidget {
  const LibraryDisciplineScreen({super.key, required this.disciplineId});

  final String disciplineId;

  static const Map<String, String> _typeSectionTitle = {
    'book': 'Books',
    'expert': 'Experts & Thinkers',
    'researchArea': 'Research Areas',
    'paper': 'Papers',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.read(contentRepositoryProvider);
    final isGeneral = disciplineId == 'general';
    final discipline = isGeneral ? null : Discipline.byId(disciplineId);
    final resources = isGeneral
        ? content.generalLibraryResources
        : content.libraryResourcesFor(disciplineId);

    final byType = <String, List<LibraryResource>>{};
    for (final r in resources) {
      byType.putIfAbsent(r.type, () => []).add(r);
    }

    final lessonCount = isGeneral ? 0 : content.lessonsFor(disciplineId).length;
    final drillCount = isGeneral ? 0 : content.drillsFor(disciplineId).length;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(isGeneral ? 'General' : discipline!.name),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
          children: [
            const SizedBox(height: PerceptSpacing.sm),
            if (!isGeneral) Text(discipline!.tagline, style: PerceptTypography.subhead(context.textSecondary)),
            for (final type in ['book', 'expert', 'researchArea', 'paper'])
              if (byType[type]?.isNotEmpty ?? false) ...[
                SectionHeader(_typeSectionTitle[type] ?? type),
                for (final resource in byType[type]!)
                  PerceptCard(
                    margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          PerceptGlyphs.libraryResourceType[type] ?? '•',
                          style: const TextStyle(fontSize: PerceptGlyphSize.row),
                        ),
                        const SizedBox(width: PerceptSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resource.title,
                                style: PerceptTypography.bodyEmphasis(context.textPrimary),
                              ),
                              if (resource.subtitle.isNotEmpty)
                                Text(
                                  resource.subtitle,
                                  style: PerceptTypography.footnote(context.perceptPrimary),
                                ),
                              const SizedBox(height: PerceptSpacing.xs),
                              Text(
                                resource.description,
                                style: PerceptTypography.subhead(context.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            if (!isGeneral) ...[
              const SectionHeader('In Percept'),
              PerceptCard(
                margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                onTap: () => context.push(
                  RoutePaths.withParam(RoutePaths.learnDisciplineDetail, 'disciplineId', disciplineId),
                ),
                child: _inPerceptRow(context, '🧠', '$lessonCount lessons'),
              ),
              PerceptCard(
                margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                onTap: () => context.push(
                  RoutePaths.withParam(RoutePaths.practiceLab, 'labCategory', discipline!.labName),
                ),
                child: _inPerceptRow(context, '👁', '$drillCount practice drills'),
              ),
              const SizedBox(height: PerceptSpacing.sm),
              PerceptCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REFLECT', style: PerceptTypography.caption(context.perceptPrimary)),
                    const SizedBox(height: 4),
                    Text(
                      'Where has ${discipline!.name.toLowerCase()} shown up in your life this week?',
                      style: PerceptTypography.body(context.textPrimary, serif: true),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: PerceptSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _inPerceptRow(BuildContext context, String glyph, String text) => Row(
    children: [
      Text(glyph, style: const TextStyle(fontSize: PerceptGlyphSize.row)),
      const SizedBox(width: PerceptSpacing.md),
      Text(text, style: PerceptTypography.bodyEmphasis(context.perceptPrimary)),
      const Spacer(),
      Icon(CupertinoIcons.chevron_forward, size: 16, color: context.textTertiary),
    ],
  );
}
