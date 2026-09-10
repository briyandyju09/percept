import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/practice_providers.dart';
import '../../theme/glyphs.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/percept_card.dart';

class HistoryLogScreen extends ConsumerWidget {
  const HistoryLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(completionHistoryProvider);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('History')),
      child: SafeArea(
        child: history.isEmpty
            ? const Center(
                child: EmptyState(
                  glyph: '📋',
                  title: 'No history yet',
                  message: 'Everything you complete shows up here.',
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
                itemCount: history.length,
                itemBuilder: (context, i) {
                  final record = history[i];
                  return PerceptCard(
                    margin: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                    child: Row(
                      children: [
                        Text(
                          PerceptGlyphs.completionType[record.contentType] ?? '•',
                          style: const TextStyle(fontSize: PerceptGlyphSize.row),
                        ),
                        const SizedBox(width: PerceptSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.contentId,
                                style: PerceptTypography.body(context.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              PerceptMetaLine([
                                '${record.completedAt.month}/${record.completedAt.day}',
                                record.contentType,
                                if (record.resultSummary != null) record.resultSummary!,
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
