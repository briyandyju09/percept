import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routing/route_paths.dart';
import '../../state/case_providers.dart';
import '../../state/repository_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class CaseInterviewScreen extends ConsumerStatefulWidget {
  const CaseInterviewScreen({super.key, required this.caseId});

  final String caseId;

  @override
  ConsumerState<CaseInterviewScreen> createState() => _CaseInterviewScreenState();
}

class _CaseInterviewScreenState extends ConsumerState<CaseInterviewScreen> {
  late String _selectedCharacterId;
  String? _expandedQuestionId;

  @override
  void initState() {
    super.initState();
    final caseFile = ref.read(contentRepositoryProvider).caseById(widget.caseId)!;
    _selectedCharacterId = caseFile.characters.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final caseFile = ref.read(contentRepositoryProvider).caseById(widget.caseId)!;
    final progress = ref.watch(caseProgressProvider(widget.caseId));
    final character = caseFile.characters.firstWhere((c) => c.id == _selectedCharacterId);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Interview'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.push(
            RoutePaths.withParam(RoutePaths.caseEvidence, 'caseId', widget.caseId),
          ),
          child: const Icon(CupertinoIcons.doc_text_search),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 92,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
                children: [
                  for (final c in caseFile.characters)
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedCharacterId = c.id;
                        _expandedQuestionId = null;
                      }),
                      child: Container(
                        width: 76,
                        margin: const EdgeInsets.only(right: PerceptSpacing.sm),
                        padding: const EdgeInsets.all(PerceptSpacing.sm),
                        decoration: BoxDecoration(
                          color: c.id == _selectedCharacterId
                              ? context.perceptPrimary.withValues(alpha: 0.1)
                              : context.perceptSurface,
                          borderRadius: BorderRadius.circular(PerceptRadii.card),
                          border: Border.all(
                            color: c.id == _selectedCharacterId
                                ? context.perceptPrimary
                                : context.perceptHairline,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(c.portraitEmoji, style: const TextStyle(fontSize: 26)),
                            const SizedBox(height: 4),
                            Text(
                              c.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: PerceptTypography.footnote(context.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: PerceptSpacing.sm),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: PerceptSpacing.screenMargin),
                children: [
                  Text(character.role, style: PerceptTypography.subhead(context.textSecondary)),
                  const SizedBox(height: PerceptSpacing.md),
                  for (final q in character.dialogueTree)
                    Padding(
                      padding: const EdgeInsets.only(bottom: PerceptSpacing.sm),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedQuestionId = _expandedQuestionId == q.id ? null : q.id;
                          });
                          ref.read(caseActionsProvider).askQuestion(widget.caseId, q);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(PerceptSpacing.cardPadding),
                          decoration: BoxDecoration(
                            color: context.perceptSurface,
                            borderRadius: BorderRadius.circular(PerceptRadii.card),
                            border: Border.all(color: context.perceptHairline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      q.prompt,
                                      style: PerceptTypography.bodyEmphasis(context.textPrimary),
                                    ),
                                  ),
                                  if (progress.questionsAsked.contains(q.id))
                                    Icon(CupertinoIcons.checkmark_alt, size: 16, color: context.perceptPrimary),
                                ],
                              ),
                              if (_expandedQuestionId == q.id) ...[
                                const SizedBox(height: PerceptSpacing.sm),
                                Text(
                                  q.responseText,
                                  style: PerceptTypography.body(context.textSecondary, serif: true),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: PerceptSpacing.xxl),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () => context.push(
                    RoutePaths.withParam(RoutePaths.caseDeduction, 'caseId', widget.caseId),
                  ),
                  child: Text('I\'m ready to accuse (${progress.questionsAsked.length} asked)'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
