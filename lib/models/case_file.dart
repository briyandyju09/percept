/// A branching interview question a player can ask a [CaseCharacter].
/// `flags` are authored metadata (never shown to the player) that the
/// [CaseReasoningAnalyzer] reads to score reasoning quality, e.g.
/// `reveals_motive`, `contradiction`, `red_herring`, `supports:char_butler`,
/// `challenges:char_butler`.
class CaseQuestion {
  const CaseQuestion({
    required this.id,
    required this.characterId,
    required this.prompt,
    required this.responseText,
    this.flags = const [],
  });

  final String id;
  final String characterId;
  final String prompt;
  final String responseText;
  final List<String> flags;

  factory CaseQuestion.fromJson(Map<String, dynamic> json) => CaseQuestion(
    id: json['id'] as String,
    characterId: json['characterId'] as String,
    prompt: json['prompt'] as String,
    responseText: json['responseText'] as String,
    flags: (json['flags'] as List<dynamic>? ?? []).cast<String>(),
  );
}

class CaseCharacter {
  const CaseCharacter({
    required this.id,
    required this.name,
    required this.role,
    this.portraitEmoji = '🧑',
    this.dialogueTree = const [],
    this.isGuilty = false,
  });

  final String id;
  final String name;
  final String role;

  /// v1 uses an emoji glyph in place of a real illustrated portrait asset.
  final String portraitEmoji;
  final List<CaseQuestion> dialogueTree;

  /// Hidden from the UI — read only by the solution check.
  final bool isGuilty;

  factory CaseCharacter.fromJson(Map<String, dynamic> json) => CaseCharacter(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
    portraitEmoji: json['portraitEmoji'] as String? ?? '🧑',
    dialogueTree: (json['dialogueTree'] as List<dynamic>? ?? [])
        .map((q) => CaseQuestion.fromJson(q as Map<String, dynamic>))
        .toList(),
    isGuilty: json['isGuilty'] as bool? ?? false,
  );
}

class CaseEvidence {
  const CaseEvidence({
    required this.id,
    required this.title,
    required this.description,
    this.subtle = false,
    this.contradicts = const [],
    this.supportsCharacterId,
  });

  final String id;
  final String title;
  final String description;
  final bool subtle;
  final List<String> contradicts;
  final String? supportsCharacterId;

  factory CaseEvidence.fromJson(Map<String, dynamic> json) => CaseEvidence(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    subtle: json['subtle'] as bool? ?? false,
    contradicts: (json['contradicts'] as List<dynamic>? ?? []).cast<String>(),
    supportsCharacterId: json['supportsCharacterId'] as String?,
  );
}

class CaseSolution {
  const CaseSolution({
    required this.correctCulpritId,
    required this.keyEvidenceIds,
    required this.explanation,
  });

  final String correctCulpritId;
  final List<String> keyEvidenceIds;
  final String explanation;

  factory CaseSolution.fromJson(Map<String, dynamic> json) => CaseSolution(
    correctCulpritId: json['correctCulpritId'] as String,
    keyEvidenceIds: (json['keyEvidenceIds'] as List<dynamic>? ?? [])
        .cast<String>(),
    explanation: json['explanation'] as String,
  );
}

class CaseFile {
  const CaseFile({
    required this.id,
    required this.caseNumber,
    required this.title,
    required this.briefing,
    required this.characters,
    required this.evidence,
    required this.solution,
    this.biasesTracked = const [],
    this.minQuestionsBeforeAccusation = 6,
  });

  final String id;
  final int caseNumber;
  final String title;
  final String briefing;
  final List<CaseCharacter> characters;
  final List<CaseEvidence> evidence;
  final CaseSolution solution;
  final List<String> biasesTracked;
  final int minQuestionsBeforeAccusation;

  factory CaseFile.fromJson(Map<String, dynamic> json) => CaseFile(
    id: json['id'] as String,
    caseNumber: json['caseNumber'] as int,
    title: json['title'] as String,
    briefing: json['briefing'] as String,
    characters: (json['characters'] as List<dynamic>? ?? [])
        .map((c) => CaseCharacter.fromJson(c as Map<String, dynamic>))
        .toList(),
    evidence: (json['evidence'] as List<dynamic>? ?? [])
        .map((e) => CaseEvidence.fromJson(e as Map<String, dynamic>))
        .toList(),
    solution: CaseSolution.fromJson(
      json['solution'] as Map<String, dynamic>,
    ),
    biasesTracked: (json['biasesTracked'] as List<dynamic>? ?? [])
        .cast<String>(),
    minQuestionsBeforeAccusation:
        json['minQuestionsBeforeAccusation'] as int? ?? 6,
  );
}
