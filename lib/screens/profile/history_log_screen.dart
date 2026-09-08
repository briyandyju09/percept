import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/practice_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/empty_state.dart';

class HistoryLogScreen extends ConsumerWidget {
  const HistoryLogScreen({super.key});

  static const Map<String, String> _glyphs = {
    'lesson': '🧠',
    'drill': '👁',
    'dailyMissionItem': '☀️',
    'conversationScenario': '🗣',
    'case': '🕵️',
  };

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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                    child: Container(
                      padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
                      decoration: BoxDecoration(
                        color: context.perceptSurface,
                        borderRadius: BorderRadius.circular(PerceptRadii.card),
                        border: Border.all(color: context.perceptHairline),
                      ),
                      child: Row(
                        children: [
                          Text(_glyphs[record.contentType] ?? '•', style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: PerceptSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(record.contentId, style: PerceptTypography.body(context.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(
                                  '${record.completedAt.month}/${record.completedAt.day} · ${record.contentType}${record.resultSummary != null ? ' · ${record.resultSummary}' : ''}',
                                  style: PerceptTypography.footnote(context.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
