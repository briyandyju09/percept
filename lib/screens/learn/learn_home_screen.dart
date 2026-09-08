import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/knowledge_card_view.dart';

class LearnHomeScreen extends ConsumerStatefulWidget {
  const LearnHomeScreen({super.key});

  @override
  ConsumerState<LearnHomeScreen> createState() => _LearnHomeScreenState();
}

class _LearnHomeScreenState extends ConsumerState<LearnHomeScreen> {
  String? _filter;
  final _pageController = PageController(viewportFraction: 0.92);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCards = ref.read(contentRepositoryProvider).knowledgeCards;
    final cards = _filter == null
        ? allCards
        : allCards.where((c) => c.disciplineId == _filter).toList();

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                PerceptSpacing.screenMargin,
                PerceptSpacing.sm,
                PerceptSpacing.screenMargin,
                0,
              ),
              child: Row(
                children: [
                  Text('Learn', style: PerceptTypography.title1(context.textPrimary)),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => context.push(RoutePaths.learnSaved),
                    child: const Icon(CupertinoIcons.bookmark),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => context.push(RoutePaths.learnDisciplines),
                    child: const Icon(CupertinoIcons.square_grid_2x2),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: PerceptSpacing.screenMargin,
                ),
                children: [
                  _filterChip(context, null, 'All'),
                  for (final d in Discipline.all) _filterChip(context, d.id, d.icon),
                ],
              ),
            ),
            const SizedBox(height: PerceptSpacing.sm),
            Expanded(
              child: cards.isEmpty
                  ? Center(
                      child: Text(
                        'No cards yet in this discipline.',
                        style: PerceptTypography.subhead(context.textSecondary),
                      ),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        final isSaved = ref.watch(isCardSavedProvider(card.id));
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PerceptSpacing.sm,
                            vertical: PerceptSpacing.sm,
                          ),
                          child: SingleChildScrollView(
                            child: KnowledgeCardView(
                              card: card,
                              isSaved: isSaved,
                              onSaveToggle: () => ref
                                  .read(practiceActionsProvider)
                                  .markCardSaved(card.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: PerceptSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(BuildContext context, String? disciplineId, String label) {
    final selected = _filter == disciplineId;
    return Padding(
      padding: const EdgeInsets.only(right: PerceptSpacing.sm),
      child: GestureDetector(
        onTap: () => setState(() => _filter = disciplineId),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.md),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? context.perceptPrimary : context.perceptSurfaceRaised,
            borderRadius: BorderRadius.circular(PerceptRadii.chip),
          ),
          child: Text(
            label,
            style: PerceptTypography.subhead(
              selected ? CupertinoColors.white : context.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
