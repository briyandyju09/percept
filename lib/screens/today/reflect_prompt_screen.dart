import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/daily_mission_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class ReflectPromptScreen extends ConsumerStatefulWidget {
  const ReflectPromptScreen({super.key});

  @override
  ConsumerState<ReflectPromptScreen> createState() => _ReflectPromptScreenState();
}

class _ReflectPromptScreenState extends ConsumerState<ReflectPromptScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(dailyMissionProvider);
    final item = items.firstWhere((i) => i.type == 'reflect');

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Reflect')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PerceptSpacing.screenMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PerceptSpacing.xl),
              const Text('📓', style: TextStyle(fontSize: PerceptGlyphSize.hero)),
              const SizedBox(height: PerceptSpacing.lg),
              Text(item.subtitle, style: PerceptTypography.title3(context.textPrimary)),
              const SizedBox(height: PerceptSpacing.lg),
              CupertinoTextField(
                controller: _controller,
                placeholder: 'A sentence or two is enough…',
                maxLines: 6,
                padding: const EdgeInsets.all(PerceptSpacing.md),
                decoration: BoxDecoration(
                  color: context.perceptSurface,
                  borderRadius: BorderRadius.circular(PerceptRadii.card),
                  border: Border.all(color: context.perceptHairline),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: item.completed
                      ? null
                      : () {
                          ref
                              .read(dailyMissionProvider.notifier)
                              .toggleComplete(item.id);
                          Navigator.of(context).maybePop();
                        },
                  child: Text(item.completed ? 'Saved ✓' : 'Save reflection'),
                ),
              ),
              const SizedBox(height: PerceptSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
