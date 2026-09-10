import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/discipline.dart';
import '../../routing/route_paths.dart';
import '../../state/profile_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class ProgramGeneratedScreen extends ConsumerWidget {
  const ProgramGeneratedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final focus = Discipline.all.firstWhere(
      (d) => d.primaryDimension == profile.dimensionScores.lowestDimensionKey,
      orElse: () => Discipline.all.first,
    );

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Your Program'),
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PerceptSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PerceptSpacing.xl),
              Text(focus.icon, style: const TextStyle(fontSize: PerceptGlyphSize.hero)),
              const SizedBox(height: PerceptSpacing.md),
              Text(
                'Your training starts with ${focus.name}',
                style: PerceptTypography.title1(context.textPrimary),
              ),
              const SizedBox(height: PerceptSpacing.sm),
              Text(
                focus.tagline,
                style: PerceptTypography.body(context.textSecondary),
              ),
              const SizedBox(height: PerceptSpacing.xl),
              Text(
                'Every day you\'ll get a short, mixed bundle:',
                style: PerceptTypography.bodyEmphasis(context.textPrimary),
              ),
              const SizedBox(height: PerceptSpacing.md),
              _row(context, '🧠', 'Learn', '~8 min — a real lesson, not a wall of text'),
              _row(context, '👁', 'Practice', '~4 min — a hands-on drill'),
              _row(context, '🗣', 'Social Challenge', 'a real action to take today'),
              _row(context, '🧘', 'Composure', '~2 min — a breathing or pressure drill'),
              _row(context, '📓', 'Reflect', '~1 min — one honest question'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: () async {
                    await ref.read(profileProvider.notifier).completeOnboarding();
                    if (context.mounted) context.go(RoutePaths.today);
                  },
                  child: const Text('Enter Percept'),
                ),
              ),
              const SizedBox(height: PerceptSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String glyph, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PerceptSpacing.xs),
      child: Row(
        children: [
          Text(glyph, style: const TextStyle(fontSize: PerceptGlyphSize.row)),
          const SizedBox(width: PerceptSpacing.md),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title  ',
                    style: PerceptTypography.subhead(context.textPrimary).copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: desc,
                    style: PerceptTypography.footnote(context.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
