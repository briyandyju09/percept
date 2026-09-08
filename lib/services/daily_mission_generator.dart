import '../data/repositories/content_repository.dart';
import '../models/daily_mission_item.dart';
import '../models/discipline.dart';
import '../models/user_profile.dart';

/// Builds today's 5-item mission bundle (idea.txt's "Daily Mission" home
/// screen: Learn ~8min / Practice ~4min / Social Challenge / Composure
/// ~2min / Reflect ~1min). Deterministic given the same date + profile +
/// content, so regenerating for an already-seen date reproduces the same
/// picks rather than reshuffling — this is the "adaptive daily plan" the
/// product brief calls for, implemented as a rule-based rotation rather
/// than a network call.
class DailyMissionGenerator {
  DailyMissionGenerator(this._content);

  final ContentRepository _content;

  List<DailyMissionItem> generateFor(String dateKey, UserProfile profile) {
    final dayIndex = _dayIndexFrom(dateKey);
    final focusDiscipline = _focusDiscipline(profile);

    final lesson = _pickLesson(focusDiscipline, dayIndex);
    final drill = _pickDrill(focusDiscipline, dayIndex);
    final challenge = _pickChallenge(dayIndex);
    final composureDrill = _pickComposureDrill(dayIndex);

    final items = <DailyMissionItem>[
      DailyMissionItem(
        id: '$dateKey-learn',
        date: dateKey,
        type: 'learn',
        refContentId: lesson?.id ?? '',
        estimatedMinutes: lesson?.estimatedMinutes ?? 8,
        title: lesson?.title ?? 'Today\'s lesson',
        subtitle: lesson?.hook ?? '',
      ),
      DailyMissionItem(
        id: '$dateKey-practice',
        date: dateKey,
        type: 'practice',
        refContentId: drill?.id ?? '',
        estimatedMinutes: drill?.estimatedMinutes ?? 4,
        title: drill?.prompt ?? 'Today\'s practice drill',
        subtitle: drill?.labCategory ?? '',
      ),
      DailyMissionItem(
        id: '$dateKey-social',
        date: dateKey,
        type: 'socialChallenge',
        refContentId: challenge?.id ?? '',
        estimatedMinutes: 1,
        title: 'Social Challenge',
        subtitle: challenge?.text ?? 'Ask someone a real question today.',
      ),
      DailyMissionItem(
        id: '$dateKey-composure',
        date: dateKey,
        type: 'composure',
        refContentId: composureDrill?.id ?? '',
        estimatedMinutes: composureDrill?.estimatedMinutes ?? 2,
        title: composureDrill?.prompt ?? '90-second breathing drill',
        subtitle: 'Composure',
      ),
      DailyMissionItem(
        id: '$dateKey-reflect',
        date: dateKey,
        type: 'reflect',
        refContentId: lesson?.id ?? '',
        estimatedMinutes: 1,
        title: 'Reflect',
        subtitle: _reflectPrompt(lesson?.tags),
      ),
    ];

    return items;
  }

  int get totalMinutes => 16;

  String _reflectPrompt(List<String>? tags) {
    if (tags == null || tags.isEmpty) {
      return 'What did you notice about yourself today?';
    }
    return 'Where did you notice "${tags.first}" today?';
  }

  int _dayIndexFrom(String dateKey) {
    // dateKey is yyyy-MM-dd; a stable integer from it is all we need for
    // deterministic rotation (no need to actually parse a DateTime).
    return dateKey.replaceAll('-', '').hashCode.abs();
  }

  /// The discipline most worth focusing today: whichever discipline maps
  /// to the user's current lowest-scoring dimension, falling back to a
  /// simple day-based rotation across all 7 if scores are perfectly flat.
  String _focusDiscipline(UserProfile profile) {
    final lowestKey = profile.dimensionScores.lowestDimensionKey;
    final match = Discipline.all.firstWhere(
      (d) => d.primaryDimension == lowestKey,
      orElse: () => Discipline.all[profile.dimensionScores.average.toInt() %
          Discipline.all.length],
    );
    return match.id;
  }

  dynamic _pickLesson(String disciplineId, int dayIndex) {
    final lessons = _content.lessonsFor(disciplineId);
    if (lessons.isEmpty) return null;
    return lessons[dayIndex % lessons.length];
  }

  dynamic _pickDrill(String disciplineId, int dayIndex) {
    final drills = _content.drillsFor(disciplineId);
    if (drills.isEmpty) return null;
    return drills[(dayIndex ~/ 3) % drills.length];
  }

  dynamic _pickChallenge(int dayIndex) {
    if (_content.dailyChallenges.isEmpty) return null;
    return _content.dailyChallenges[dayIndex % _content.dailyChallenges.length];
  }

  dynamic _pickComposureDrill(int dayIndex) {
    final drills = _content.drillsFor('composure');
    if (drills.isEmpty) return null;
    final breathing = drills
        .where((d) => d.type.name == 'breathingTimer')
        .toList();
    final pool = breathing.isNotEmpty ? breathing : drills;
    return pool[dayIndex % pool.length];
  }
}
