import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/platform.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glyph.dart';
import '../../domain/models/board.dart';
import '../providers/game_provider.dart';

// ── Digit Pad ─────────────────────────────────────────────────────────────────

class DigitPad extends ConsumerWidget {
  const DigitPad({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    final board = state.board;
    if (board == null) return const SizedBox.shrink();

    final n = board.size;

    return Row(
      children: [
        for (int digit = 1; digit <= n; digit++) ...[
          Flexible(
            child: _DigitButton(
              digit: digit,
              board: board,
              height: height,
              onTap: () =>
                  ref.read(gameNotifierProvider.notifier).inputDigit(digit),
            ),
          ),
          if (digit < n) SizedBox(width: height * 0.08),
        ],
      ],
    );
  }
}

class _DigitButton extends StatelessWidget {
  const _DigitButton({
    required this.digit,
    required this.board,
    required this.height,
    required this.onTap,
  });

  final int digit;
  final FutoshikiBoard board;
  final double height;
  final VoidCallback onTap;

  bool _isComplete() {
    int total = 0;
    int correct = 0;
    for (final row in board.cells) {
      for (final cell in row) {
        if (board.getSolution(cell.row, cell.col) == digit) {
          total++;
          if (cell.value == digit && !cell.isError) correct++;
        }
      }
    }
    return total > 0 && correct == total;
  }

  @override
  Widget build(BuildContext context) {
    final complete = _isComplete();
    final colour = digitPadColour(digit);

    Widget button = SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: complete ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: colour,
          disabledBackgroundColor: colour,
          foregroundColor: kDigitPadText,
          disabledForegroundColor: kDigitPadText,
          padding: EdgeInsets.zero,
          minimumSize: Size(0, height),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height * 0.22),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$digit',
            style: TextStyle(
              fontSize: height * 0.45,
              fontWeight: FontWeight.bold,
              color: kDigitPadText,
            ),
          ),
        ),
      ),
    );

    if (complete) {
      button = Stack(
        children: [
          Opacity(opacity: 0.35, child: button),
          const Positioned(
            top: 4,
            right: 4,
            child: Icon(Icons.check, size: 12, color: Colors.black54),
          ),
        ],
      );
    }

    return button;
  }
}

// ── Action Row ────────────────────────────────────────────────────────────────

class ActionRow extends ConsumerWidget {
  const ActionRow({super.key, required this.height, this.extra = const []});

  final double height;

  /// Extra buttons appended after Hint and Erase (web controls).
  final List<Widget> extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(gameNotifierProvider.notifier);
    final gap = SizedBox(width: height * 0.15);
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: ActionButton(
              label: 'Hint',
              emoji: '💡',
              icon: Icons.lightbulb_outline,
              background: kHintButton,
              onPressed: notifier.useHint,
              height: height,
            ),
          ),
          gap,
          Expanded(
            child: ActionButton(
              label: 'Erase',
              emoji: '🧹',
              icon: Icons.backspace_outlined,
              onPressed: notifier.eraseCell,
              height: height,
            ),
          ),
          for (final w in extra) ...[gap, Expanded(child: w)],
        ],
      ),
    );
  }
}

/// A control-row button whose label shrinks instead of overflowing.
/// Filled when [background] is set, outlined otherwise.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.emoji,
    required this.icon,
    required this.onPressed,
    required this.height,
    this.background,
    this.selected = false,
  });

  final String label;
  final String emoji;
  final IconData icon;
  final VoidCallback? onPressed;
  final double height;
  final Color? background;

  /// Toggle buttons (Notes) show their "on" state with a tinted fill.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(height * 0.26),
    );
    final textStyle = TextStyle(
      fontSize: (height * 0.34).clamp(11.0, 18.0),
      fontWeight: FontWeight.bold,
    );
    final child = FittedBox(
      fit: BoxFit.scaleDown,
      child: GlyphLabel(label, emoji, icon, leading: true, style: textStyle),
    );
    const padding = EdgeInsets.symmetric(horizontal: 6);

    if (background != null || selected) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background ?? kSecondary.withValues(alpha: 0.6),
          foregroundColor: Colors.black87,
          padding: padding,
          minimumSize: Size(0, height),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: shape,
        ),
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isWebEmbed ? kSiteNavy : null,
        side: BorderSide(color: Colors.grey.shade400),
        padding: padding,
        minimumSize: Size(0, height),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: shape,
      ),
      child: child,
    );
  }
}
