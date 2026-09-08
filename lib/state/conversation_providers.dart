import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/completion_record.dart';
import '../models/conversation.dart';
import 'profile_providers.dart';
import 'repository_providers.dart';
import 'revision_providers.dart';

/// Transient state for one in-progress play of a [ConversationScenario].
/// Not persisted — a play session that's interrupted just restarts; only
/// the final score is recorded.
class ConversationSessionState {
  const ConversationSessionState({
    required this.scenario,
    required this.transcript,
    this.finished = false,
    this.result,
  });

  final ConversationScenario scenario;
  final List<ConversationTurn> transcript;
  final bool finished;
  final ConversationScoringResult? result;

  /// How many NPC turns remain to be shown after the user's next reply.
  int get nextNpcTurnIndex =>
      transcript.where((t) => t.speaker == 'user').length - 1;

  bool get isComplete =>
      transcript.where((t) => t.speaker == 'user').length >
      scenario.npcTurns.length;

  ConversationSessionState copyWith({
    List<ConversationTurn>? transcript,
    bool? finished,
    ConversationScoringResult? result,
  }) {
    return ConversationSessionState(
      scenario: scenario,
      transcript: transcript ?? this.transcript,
      finished: finished ?? this.finished,
      result: result ?? this.result,
    );
  }
}

class ConversationSessionNotifier extends Notifier<ConversationSessionState?> {
  @override
  ConversationSessionState? build() => null;

  void start(ConversationScenario scenario) {
    state = ConversationSessionState(
      scenario: scenario,
      transcript: [
        ConversationTurn(
          speaker: 'npc',
          text: scenario.openingLine,
          timestampMs: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
    );
  }

  /// Records the user's reply, then appends the next scripted NPC turn (if
  /// any remain) or marks the session complete.
  void submitReply(String text) {
    final current = state;
    if (current == null || current.finished) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    var transcript = [
      ...current.transcript,
      ConversationTurn(speaker: 'user', text: text, timestampMs: now),
    ];

    final userTurnCount = transcript.where((t) => t.speaker == 'user').length;
    final npcTurnIndex = userTurnCount - 1;
    if (npcTurnIndex < current.scenario.npcTurns.length) {
      transcript = [
        ...transcript,
        ConversationTurn(
          speaker: 'npc',
          text: current.scenario.npcTurns[npcTurnIndex].text,
          timestampMs: now + 1,
        ),
      ];
    }

    final complete = npcTurnIndex >= current.scenario.npcTurns.length - 1;
    state = current.copyWith(transcript: transcript, finished: complete);
  }

  Future<ConversationScoringResult> finishAndScore() async {
    final current = state!;
    final result = ref
        .read(conversationScorerProvider)
        .score(current.scenario, current.transcript);
    state = current.copyWith(result: result, finished: true);

    await ref.read(progressRepositoryProvider).addCompletion(
      CompletionRecord(
        id: 'conv-${current.scenario.id}-${DateTime.now().millisecondsSinceEpoch}',
        contentId: current.scenario.id,
        contentType: 'conversationScenario',
        completedAt: DateTime.now(),
        resultSummary: '${result.score}',
      ),
    );
    ref.read(completionsRevisionProvider.notifier).state++;

    final delta = result.score >= 70 ? 2 : 1;
    await ref
        .read(profileProvider.notifier)
        .adjustDimension('communication', delta);

    return result;
  }

  void reset() => state = null;
}

final conversationSessionProvider =
    NotifierProvider<ConversationSessionNotifier, ConversationSessionState?>(
  ConversationSessionNotifier.new,
);
