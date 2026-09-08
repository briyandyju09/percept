import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/discipline.dart';
import '../../models/progress_entry.dart';
import '../../state/practice_providers.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/empty_state.dart';

class TrendChartsScreen extends ConsumerWidget {
  const TrendChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = [for (final d in Discipline.all) 'drillScore_${d.labName}'];
    final byMetric = {
      for (final m in metrics) m: ref.watch(progressEntriesForMetricProvider(m)),
    }..removeWhere((_, entries) => entries.length < 2);

    return CupertinoPageScaffold(
      backgroundColor: context.perceptBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('Trends')),
      child: SafeArea(
        child: byMetric.isEmpty
            ? const Center(
                child: EmptyState(
                  glyph: '📈',
                  title: 'Not enough data yet',
                  message: 'Complete a few drills in the same lab and your trend will appear here.',
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(PerceptSpacing.screenMargin),
                children: [
                  for (final entry in byMetric.entries)
                    _TrendCard(
                      title: entry.key.replaceFirst('drillScore_', ''),
                      data: entry.value,
                    ),
                ],
              ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.title, required this.data});

  final String title;
  final List<ProgressEntry> data;

  @override
  Widget build(BuildContext context) {
    final first = data.first.value;
    final last = data.last.value;
    final delta = last - first;

    return Container(
      margin: const EdgeInsets.only(bottom: PerceptSpacing.md),
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
              Expanded(child: Text(title, style: PerceptTypography.bodyEmphasis(context.textPrimary))),
              Text(
                '${delta >= 0 ? '+' : ''}${delta.round()}',
                style: PerceptTypography.bodyEmphasis(
                  delta >= 0 ? context.perceptPrimary : context.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: PerceptSpacing.md),
          SizedBox(
            height: 60,
            child: CustomPaint(
              size: Size.infinite,
              painter: _SparklinePainter(
                values: data.map((e) => e.value).toList(),
                color: context.perceptPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce((a, b) => a > b ? a : b).clamp(1, 100);
    final minV = values.reduce((a, b) => a < b ? a : b).clamp(0, 99);
    final range = (maxV - minV).clamp(1, 100);

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * (i / (values.length - 1));
      final y = size.height - (size.height * ((values[i] - minV) / range));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values;
}
