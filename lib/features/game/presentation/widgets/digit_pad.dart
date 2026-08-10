import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/board.dart';
import '../providers/game_provider.dart';

// ── Digit Pad ─────────────────────────────────────────────────────────────────

class DigitPad extends ConsumerWidget {
  const DigitPad({super.key});

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
              onTap: () =>
                  ref.read(gameNotifierProvider.notifier).inputDigit(digit),
            ),
          ),
          if (digit < n) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class _DigitButton extends StatelessWidget {
  const _DigitButton({
    required this.digit,
    required this.board,
    required this.onTap,
  });

  final int digit;
  final FutoshikiBoard board;
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
    final colour = kDigitPadColours[digit]!;

    Widget button = SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: complete ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: colour,
          disabledBackgroundColor: colour,
          foregroundColor: Colors.black87,
          disabledForegroundColor: Colors.black87,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(
          '$digit',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
  const ActionRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () =>
                  ref.read(gameNotifierProvider.notifier).useHint(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('💡 Hint'),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: () =>
                  ref.read(gameNotifierProvider.notifier).eraseCell(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('🧹 Erase'),
            ),
          ),
        ),
      ],
    );
  }
}
