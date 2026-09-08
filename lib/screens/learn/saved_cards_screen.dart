import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/knowledge_card.dart';
import '../../state/practice_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/knowledge_card_view.dart';

class SavedCardsScreen extends ConsumerWidget {
  const SavedCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedCardsListProvider);
    final content = ref.read(contentRepositoryProvider);
    final cards = saved
        .map((s) => content.cardById(s.cardId))
        .whereType<KnowledgeCard>()
        .toList();

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Saved')),
      child: SafeArea(
        child: cards.isEmpty
            ? const Center(
                child: EmptyState(
                  glyph: '🔖',
                  title: 'Nothing saved yet',
                  message: 'Tap the bookmark on any card in Learn to keep it here.',
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
                children: [
                  for (final card in cards)
                    Padding(
                      padding: const EdgeInsets.only(bottom: PerceptSpacing.md),
                      child: KnowledgeCardView(
                        card: card,
                        isSaved: true,
                        onSaveToggle: () => ref
                            .read(practiceActionsProvider)
                            .markCardSaved(card.id),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
