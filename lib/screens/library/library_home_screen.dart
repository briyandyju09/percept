import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/percept_card.dart';

/// The Library tab root: a browsable shelf of real books, researchers,
/// and research areas — one section per discipline, plus a cross-cutting
/// "General" section — replacing idea.txt's "Knowledge Graph" concept as
/// a first-class destination rather than a link buried in Learn.
class LibraryHomeScreen extends ConsumerWidget {
  const LibraryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.read(contentRepositoryProvider);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CupertinoSliverNavigationBar(largeTitle: Text('Library')),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    'Real books, researchers, and research areas behind everything '
                    "Percept teaches — nothing fabricated, nothing oversold.",
                    style: PerceptTypography.subhead(context.textSecondary),
                  ),
                  const SizedBox(height: PerceptSpacing.lg),
                  for (final discipline in Discipline.all)
                    _LibraryTile(
                      icon: discipline.icon,
                      title: discipline.name,
                      count: content.libraryResourcesFor(discipline.id).length,
                      onTap: () => context.push(
                        RoutePaths.withParam(
                          RoutePaths.libraryDiscipline,
                          'disciplineId',
                          discipline.id,
                        ),
                      ),
                    ),
                  _LibraryTile(
                    icon: '🌐',
                    title: 'General',
                    count: content.generalLibraryResources.length,
                    onTap: () => context.push(
                      RoutePaths.withParam(
                        RoutePaths.libraryDiscipline,
                        'disciplineId',
                        'general',
                      ),
                    ),
                  ),
                  const SizedBox(height: PerceptSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryTile extends StatelessWidget {
  const _LibraryTile({
    required this.icon,
    required this.title,
    required this.count,
    required this.onTap,
  });

  final String icon;
  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PerceptCard(
      margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
      onTap: onTap,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: PerceptGlyphSize.row)),
          const SizedBox(width: PerceptSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
                Text(
                  '$count resources',
                  style: PerceptTypography.footnote(context.textSecondary),
                ),
              ],
            ),
          ),
          Icon(CupertinoIcons.chevron_forward, size: 18, color: context.textTertiary),
        ],
      ),
    );
  }
}
