import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/conversation_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class ConversationSimulatorScreen extends ConsumerStatefulWidget {
  const ConversationSimulatorScreen({super.key, required this.scenarioId});

  final String scenarioId;

  @override
  ConsumerState<ConversationSimulatorScreen> createState() =>
      _ConversationSimulatorScreenState();
}

class _ConversationSimulatorScreenState
    extends ConsumerState<ConversationSimulatorScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final scenario = ref.read(contentRepositoryProvider).conversationScenarios
        .firstWhere((s) => s.id == widget.scenarioId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationSessionProvider.notifier).start(scenario);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(conversationSessionProvider);
    if (session == null) {
      return const CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator()));
    }
    _scrollToBottom();

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(middle: Text(session.scenario.title)),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
              child: Text(
                session.scenario.setup,
                style: PerceptTypography.footnote(context.textSecondary),
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
                children: [
                  for (final turn in session.transcript) _bubble(context, turn),
                ],
              ),
            ),
            if (session.finished)
              Padding(
                padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () async {
                      await ref.read(conversationSessionProvider.notifier).finishAndScore();
                      if (context.mounted) {
                        context.pushReplacement(
                          RoutePaths.withParam(
                            RoutePaths.practiceConversationResult,
                            'scenarioId',
                            widget.scenarioId,
                          ),
                        );
                      }
                    },
                    child: const Text('See my results'),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: _controller,
                        placeholder: 'Type your reply…',
                        padding: const EdgeInsets.all(PerceptSpacing.md),
                        decoration: BoxDecoration(
                          color: context.perceptSurface,
                          borderRadius: BorderRadius.circular(PerceptRadii.card),
                          border: Border.all(color: context.perceptHairline),
                        ),
                      ),
                    ),
                    const SizedBox(width: PerceptSpacing.sm),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.all(PerceptSpacing.md),
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) return;
                        ref
                            .read(conversationSessionProvider.notifier)
                            .submitReply(_controller.text.trim());
                        _controller.clear();
                      },
                      child: const Icon(CupertinoIcons.arrow_up),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(BuildContext context, dynamic turn) {
    final isUser = turn.speaker == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: PerceptSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: PerceptSpacing.md,
          vertical: PerceptSpacing.sm,
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? context.perceptPrimary : context.perceptSurfaceRaised,
          borderRadius: BorderRadius.circular(PerceptRadii.card),
        ),
        child: Text(
          turn.text,
          style: PerceptTypography.body(isUser ? CupertinoColors.white : context.textPrimary),
        ),
      ),
    );
  }
}
