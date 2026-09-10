import 'package:flutter/cupertino.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// The single shared "card" shell used everywhere a screen groups content
/// into a tappable or non-tappable block — replaces what used to be five
/// hand-copied `Container` + `BoxDecoration` blocks across the app.
///
/// Defaults to a background-tint-only look (no hairline border) — per
/// the brand rule already stated in `spacing.dart`'s doc comment,
/// separation comes from background contrast, not borders or shadows.
/// Pass [bordered] true only where a border genuinely earns its place
/// (e.g. a dense list of otherwise-identical rows that needs a crisper
/// edge between items).
class PerceptCard extends StatelessWidget {
  const PerceptCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.bordered = false,
    this.margin,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(PerceptSpacing.cardPadding),
      decoration: BoxDecoration(
        color: context.perceptSurface,
        borderRadius: BorderRadius.circular(PerceptRadii.card),
        border: bordered ? Border.all(color: context.perceptHairline) : null,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}

/// A single plain caption-style metadata line ("6 min · Quick Brief")
/// used instead of a row of small bordered chips — one calmer, quieter
/// way to show 2-3 secondary facts about a lesson/drill without stacking
/// multiple pill shapes per row.
class PerceptMetaLine extends StatelessWidget {
  const PerceptMetaLine(this.parts, {super.key});

  final List<String> parts;

  @override
  Widget build(BuildContext context) {
    return Text(
      parts.where((p) => p.isNotEmpty).join(' · '),
      style: PerceptTypography.caption(context.textTertiary),
    );
  }
}
