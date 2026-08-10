import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/logic/futoshiki_engine.dart';
import '../../domain/models/cell.dart';
import '../../domain/models/constraint.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';

class FutoshikiGrid extends ConsumerWidget {
  const FutoshikiGrid({super.key});

  static const double _constraintSlotW = 26.0;
  static const double _constraintSlotH = 26.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    final board = state.board;
    if (board == null) return const SizedBox.shrink();

    final n = board.size;
    final showConstraintErrors =
        state.showBrokenInequalities && state.showWrongMoves;
    final constraintStyle = ref.watch(constraintStyleNotifierProvider);

    return Container(
      decoration: BoxDecoration(
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalSlotWidth = (n - 1) * _constraintSlotW;
            final cellSize = (constraints.maxWidth - totalSlotWidth) / n;

            return Column(
              mainAxisSize: MainAxisSize.min,
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
                          _HConstraintWidget(
                            width: _constraintSlotW,
                            height: cellSize,
                            constraint:
                                FutoshikiEngine().hConstraint(board, r, c),
                            leftValue: board.cells[r][c].value,
                            rightValue: board.cells[r][c + 1].value,
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
                          _VConstraintWidget(
                            width: cellSize,
                            height: _constraintSlotH,
                            constraint:
                                FutoshikiEngine().vConstraint(board, r, c),
                            topValue: board.cells[r][c].value,
                            bottomValue: board.cells[r + 1][c].value,
                            showErrors: showConstraintErrors,
                            style: constraintStyle,
                          ),
                          if (c < n - 1) SizedBox(width: _constraintSlotW),
                        ],
                      ],
                    ),
                ],
              ],
            );
          },
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
      bgColor = kPrimary.withValues(alpha: 0.40);
    } else if (cell.isSameDigit) {
      bgColor = kSecondary.withValues(alpha: 0.35);
    } else if (cell.isHighlighted) {
      bgColor = kPrimary.withValues(alpha: 0.12);
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
        textColor = const Color(0xFF7B1FA2);
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
            fontSize: size * 0.44,
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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: n,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        final d = i + 1;
        return Center(
          child: Text(
            marks.contains(d) ? '$d' : '',
            style: TextStyle(
              fontSize: size * 0.17,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade500,
            ),
          ),
        );
      },
    );
  }
}

// ── Horizontal constraint ─────────────────────────────────────────────────────

class _HConstraintWidget extends StatelessWidget {
  const _HConstraintWidget({
    required this.width,
    required this.height,
    required this.constraint,
    required this.leftValue,
    required this.rightValue,
    required this.showErrors,
    required this.style,
  });

  final double width;
  final double height;
  final FutoshikiConstraint? constraint;
  final int leftValue;
  final int rightValue;
  final bool showErrors;
  final ConstraintStyle style;

  String _symbol(bool isLessThan) => switch (style) {
        ConstraintStyle.classic => isLessThan ? '<' : '>',
        // tip points toward the smaller cell
        ConstraintStyle.arrows => isLessThan ? '←' : '→',
        ConstraintStyle.triangles => isLessThan ? '◁' : '▷',
      };

  @override
  Widget build(BuildContext context) {
    if (constraint == null) {
      return SizedBox(width: width, height: height);
    }

    final symbol = _symbol(constraint!.isLessThan);
    final isViolated = showErrors &&
        leftValue != 0 &&
        rightValue != 0 &&
        ((constraint!.isLessThan && leftValue >= rightValue) ||
            (!constraint!.isLessThan && leftValue <= rightValue));

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isViolated ? kConstraintErr : kConstraint,
          ),
        ),
      ),
    );
  }
}

// ── Vertical constraint ───────────────────────────────────────────────────────

class _VConstraintWidget extends StatelessWidget {
  const _VConstraintWidget({
    required this.width,
    required this.height,
    required this.constraint,
    required this.topValue,
    required this.bottomValue,
    required this.showErrors,
    required this.style,
  });

  final double width;
  final double height;
  final FutoshikiConstraint? constraint;
  final int topValue;
  final int bottomValue;
  final bool showErrors;
  final ConstraintStyle style;

  String _symbol(bool isLessThan) => switch (style) {
        ConstraintStyle.classic => isLessThan ? '∨' : '∧',
        // tip points toward the smaller cell
        ConstraintStyle.arrows => isLessThan ? '↑' : '↓',
        ConstraintStyle.triangles => isLessThan ? '△' : '▽',
      };

  @override
  Widget build(BuildContext context) {
    if (constraint == null) {
      return SizedBox(width: width, height: height);
    }

    final symbol = _symbol(constraint!.isLessThan);
    final isViolated = showErrors &&
        topValue != 0 &&
        bottomValue != 0 &&
        ((constraint!.isLessThan && topValue >= bottomValue) ||
            (!constraint!.isLessThan && topValue <= bottomValue));

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isViolated ? kConstraintErr : kConstraint,
          ),
        ),
      ),
    );
  }
}
