import 'package:flutter/material.dart';
import '../platform.dart';

/// Shows [emoji] on mobile and a Material [icon] on web.
///
/// Emoji on Flutter web make the engine download a colour-emoji font from
/// Google; the bundled Material icons need nothing extra.
class Glyph extends StatelessWidget {
  const Glyph(this.emoji, this.icon, {super.key, this.size, this.color});

  final String emoji;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (isWebEmbed) return Icon(icon, size: size, color: color);
    return Text(emoji, style: TextStyle(fontSize: size));
  }
}

/// [text] followed by a [Glyph] (emoji on mobile, icon on web).
class GlyphLabel extends StatelessWidget {
  const GlyphLabel(
    this.text,
    this.emoji,
    this.icon, {
    super.key,
    this.style,
    this.leading = false,
  });

  final String text;
  final String emoji;
  final IconData icon;
  final TextStyle? style;

  /// Put the glyph before the text instead of after it.
  final bool leading;

  @override
  Widget build(BuildContext context) {
    final size = style?.fontSize ?? DefaultTextStyle.of(context).style.fontSize;
    final glyph = Glyph(emoji, icon, size: size, color: style?.color);
    final label = Flexible(child: Text(text, style: style));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: leading
          ? [glyph, const SizedBox(width: 6), label]
          : [label, const SizedBox(width: 6), glyph],
    );
  }
}
