import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/platform.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/logic/futoshiki_engine.dart';
import '../../domain/models/cell.dart';
import '../../domain/models/constraint.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import 'constraint_symbol.dart';

class FutoshikiGrid extends ConsumerWidget {
  const FutoshikiGrid({super.key, required this.size});

  /// Side length of the (square) board in logical pixels.
  final double size;

  /// Width of the gap holding an inequality symbol, relative to a cell.
  static const double gapRatio = 0.42;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    final board = state.board;
    if (board == null) return SizedBox.square(dimension: size);

    final n = board.size;
    final showConstraintErrors = state.showBrokenInequalities;
    final constraintStyle = ref.watch(constraintStyleNotifierProvider);
    final engine = FutoshikiEngine();

    // n cells + (n - 1) gaps fill the board exactly.
    final cellSize = size / (n + gapRatio * (n - 1));
    final gap = cellSize * gapRatio;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Web: ivory gaps between cells (otherwise the shadow shows through).
        color: isWebEmbed ? kBackground : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            for (int r = 0; r < n; r++) ...[
              Row(
                children: [
                  for (int c = 0; c < n; c++) ...[
                    _CellWidget(
                      cell: board.cells[r][c],
                      size: cellSize,
                      boardSize: n,
                      onTap: () => ref
                          .read(gameNotifierProvider.notifier)
                          .selectCell(r, c),
                    ),
                    if (c < n - 1)
                      _ConstraintSlot(
                        width: gap,
                        height: cellSize,
                        constraint: engine.hConstraint(board, r, c),
                        firstValue: board.cells[r][c].value,
                        secondValue: board.cells[r][c + 1].value,
                        showErrors: showConstraintErrors,
                        style: constraintStyle,
                      ),
                  ],
                ],
              ),
              if (r < n - 1)
                Row(
                  children: [
                    for (int c = 0; c < n; c++) ...[
                      _ConstraintSlot(
                        width: cellSize,
                        height: gap,
                        constraint: engine.vConstraint(board, r, c),
                        firstValue: board.cells[r][c].value,
                        secondValue: board.cells[r + 1][c].value,
                        showErrors: showConstraintErrors,
                        style: constraintStyle,
                      ),
                      if (c < n - 1) SizedBox(width: gap),
                    ],
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Cell ──────────────────────────────────────────────────────────────────────

class _CellWidget extends StatelessWidget {
  const _CellWidget({
    required this.cell,
    required this.size,
    required this.boardSize,
    required this.onTap,
  });

  final FutoshikiCell cell;
  final double size;
  final int boardSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    if (cell.isSelected) {
      bgColor = kSelectedCell;
    } else if (cell.isSameDigit) {
      bgColor = kSameDigitCell;
    } else if (cell.isHighlighted) {
      bgColor = kHighlightCell;
    } else {
      bgColor = Colors.white;
    }

    Color? textColor;
    if (cell.value != 0) {
      if (cell.isError) {
        textColor = Colors.red.shade600;
      } else if (cell.isFixed) {
        textColor = kCellFixed;
      } else if (cell.isRevealed) {
        textColor = kRevealed;
      } else {
        textColor = kPrimary;
      }
    }

    Widget cellContent;
    if (cell.value != 0) {
      cellContent = Center(
        child: Text(
          '${cell.value}',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      );
    } else if (cell.pencilMarks.isNotEmpty) {
      cellContent = _PencilMarkGrid(
        marks: cell.pencilMarks,
        n: boardSize,
        size: size,
      );
    } else {
      cellContent = const SizedBox.shrink();
    }

    Widget content = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: cellContent,
    );

    if (cell.isError) {
      content = content
          .animate(
            key: ValueKey('err_${cell.row}_${cell.col}_${cell.value}'),
          )
          .shake(hz: 5, duration: 300.ms);
    } else if (cell.isSelected) {
      content = content
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: 700.ms,
            curve: Curves.easeInOut,
          );
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (!cell.isFixed && !cell.isRevealed) onTap();
      },
      child: content,
    );
  }
}

// ── Pencil mark grid ──────────────────────────────────────────────────────────

class _PencilMarkGrid extends StatelessWidget {
  const _PencilMarkGrid({
    required this.marks,
    required this.n,
    required this.size,
  });

  final List<int> marks;
  final int n;
  final double size;

  @override
  Widget build(BuildContext context) {
    // 3 columns; plain rows (not a GridView) so nothing in the board is a
    // scrollable.
    final style = TextStyle(
      fontSize: size * 0.2,
      height: 1,
      fontWeight: FontWeight.w600,
      color: Colors.blueGrey.shade600,
    );
    final rows = (n + 2) ~/ 3;
    return Padding(
      padding: EdgeInsets.all(size * 0.06),
      child: Column(
        children: [
          for (int r = 0; r < rows; r++)
            Expanded(
              child: Row(
                children: [
                  for (int c = 0; c < 3; c++)
                    Expanded(
                      child: Center(
                        child: Text(
                          marks.contains(r * 3 + c + 1) ? '${r * 3 + c + 1}' : '',
                          style: style,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Constraint slot ───────────────────────────────────────────────────────────

/// The gap between two cells, showing the inequality between them (if any).
class _ConstraintSlot extends StatelessWidget {
  const _ConstraintSlot({
    required this.width,
    required this.height,
    required this.constraint,
    required this.firstValue,
    required this.secondValue,
    required this.showErrors,
    required this.style,
  });

  final double width;
  final double height;
  final FutoshikiConstraint? constraint;

  /// Left (horizontal) or top (vertical) cell value, then the other one.
  final int firstValue;
  final int secondValue;
  final bool showErrors;
  final ConstraintStyle style;

  @override
  Widget build(BuildContext context) {
    final con = constraint;
    if (con == null) return SizedBox(width: width, height: height);

    final isViolated = showErrors &&
        firstValue != 0 &&
        secondValue != 0 &&
        (con.isLessThan
            ? firstValue >= secondValue
            : firstValue <= secondValue);

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: ConstraintSymbol(
          dir: con.isHorizontal
              ? ConstraintSymbol.horizontal(con.isLessThan)
              : ConstraintSymbol.vertical(con.isLessThan),
          style: style,
          color: isViolated ? kConstraintErr : kConstraint,
          size: (width < height ? width : height) * 0.62,
        ),
      ),
    );
  }
}
