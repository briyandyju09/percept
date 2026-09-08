/// The 6 lesson presentation "modes" from idea.txt's audio-mode concept.
/// In v1 there is no real audio pipeline — each mode instead drives a
/// distinct *reading* layout in [LessonReaderScreen], so the different
/// feels (quick brief vs. deep dive vs. story vs. Socratic questioning vs.
/// case study vs. pure-exercise coach) are real today and can be handed to
/// a text-to-speech/audio pipeline later without changing the content
/// model.
enum LessonMode { quickBrief, deepDive, story, socratic, caseStudy, coach }

LessonMode lessonModeFromString(String value) {
  return LessonMode.values.firstWhere(
    (m) => m.name == value,
    orElse: () => LessonMode.quickBrief,
  );
}

/// A single content block inside a [Lesson]. Kept intentionally simple
/// (a type tag + text) so lesson JSON stays easy to hand-author.
class LessonBlock {
  const LessonBlock({required this.type, required this.text, this.meta});

  /// paragraph | quote | mythVsFact | keyPoint | question
  final String type;
  final String text;

  /// For `mythVsFact` blocks: `{"myth": "...", "fact": "..."}`.
  final Map<String, dynamic>? meta;

  factory LessonBlock.fromJson(Map<String, dynamic> json) => LessonBlock(
    type: json['type'] as String,
    text: json['text'] as String? ?? '',
    meta: json['meta'] as Map<String, dynamic>?,
  );
}

class Lesson {
  const Lesson({
    required this.id,
    required this.disciplineId,
    required this.title,
    required this.hook,
    required this.mode,
    required this.blocks,
    required this.estimatedMinutes,
    this.tags = const [],
    this.relatedDrillIds = const [],
    this.relatedCardIds = const [],
  });

  final String id;
  final String disciplineId;
  final String title;
  final String hook;
  final LessonMode mode;
  final List<LessonBlock> blocks;
  final int estimatedMinutes;
  final List<String> tags;
  final List<String> relatedDrillIds;
  final List<String> relatedCardIds;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json['id'] as String,
    disciplineId: json['disciplineId'] as String,
    title: json['title'] as String,
    hook: json['hook'] as String,
    mode: lessonModeFromString(json['mode'] as String? ?? 'quickBrief'),
    blocks: (json['blocks'] as List<dynamic>? ?? [])
        .map((b) => LessonBlock.fromJson(b as Map<String, dynamic>))
        .toList(),
    estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
    tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
    relatedDrillIds: (json['relatedDrillIds'] as List<dynamic>? ?? [])
        .cast<String>(),
    relatedCardIds: (json['relatedCardIds'] as List<dynamic>? ?? [])
        .cast<String>(),
  );
}
