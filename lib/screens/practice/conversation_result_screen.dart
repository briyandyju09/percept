import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/conversation_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class ConversationResultScreen extends ConsumerWidget {
  const ConversationResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(conversationSessionProvider);
    final result = session?.result;

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(automaticallyImplyLeading: false),
      child: SafeArea(
        child: result == null
            ? const Center(child: CupertinoActivityIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
                child: Column(
                  children: [
                    const SizedBox(height: PerceptSpacing.xl),
                    Text('Conversation Score', style: PerceptTypography.caption(context.perceptPrimary)),
                    const SizedBox(height: 4),
                    Text('${result.score}', style: PerceptTypography.display(context.textPrimary)),
                    const SizedBox(height: PerceptSpacing.lg),
                    Expanded(
                      child: ListView(
                        children: [
                          _statRow(context, 'Questions asked', '${result.questionsAsked}'),
                          _statRow(context, 'Follow-up rate', '${(result.followUpRate * 100).round()}%'),
                          _statRow(context, 'Questions you let pass', '${result.ignoredQuestionCount}'),
                          _statRow(context, 'Emotional-awareness phrases', '${result.emotionalAwarenessHits}'),
                          _statRow(context, 'Conversational balance', '${(result.balanceScore * 100).round()}%'),
                          const SizedBox(height: PerceptSpacing.lg),
                          Container(
                            padding: const EdgeInsets.all(PerceptSpacing.lg),
                            decoration: BoxDecoration(
                              color: PerceptColors.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(PerceptRadii.card),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final line in result.feedbackLines)
                                  Text(line, style: PerceptTypography.body(context.textPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: () {
                          ref.read(conversationSessionProvider.notifier).reset();
                          while (context.canPop()) {
                            context.pop();
                          }
                        },
                        child: const Text('Done'),
                      ),
                    ),
                    const SizedBox(height: PerceptSpacing.lg),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _statRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: PerceptTypography.subhead(context.textSecondary))),
          Text(value, style: PerceptTypography.bodyEmphasis(context.textPrimary)),
        ],
      ),
    );
  }
}
