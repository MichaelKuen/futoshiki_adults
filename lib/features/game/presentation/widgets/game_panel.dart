import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/platform.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glyph.dart';
import '../../domain/models/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import 'constraint_symbol.dart';

class GamePanel extends ConsumerWidget {
  const GamePanel({super.key, this.scrollable = true});

  /// Scrolls in the mobile drawer. Elsewhere the caller scales the panel to
  /// fit (FittedBox), so nothing inside the web embed scrolls.
  final bool scrollable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constraintStyle = ref.watch(constraintStyleNotifierProvider);
    const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 12);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Place Numbers ───────────────────────────────────────────
        const _SectionHeader('Place Numbers'),
        const SizedBox(height: 2),
        const _PlaceModeOption(label: 'Solution', value: PlaceMode.solution),
        const _PlaceModeOption(
            label: 'Pencil Marks', value: PlaceMode.pencilMarks),

        const _PanelDivider(),

        // ── Solving Aids ────────────────────────────────────────────
        const _SectionHeader('Solving Aids'),
        const SizedBox(height: 2),
        _PanelCheckbox(
          label: 'Show Repeated Digits',
          getter: (s) => s.showRepeatedDigits,
          onToggle: (ref) => ref
              .read(gameNotifierProvider.notifier)
              .toggleShowRepeatedDigits(),
        ),
        _PanelCheckbox(
          label: 'Show Broken Inequalities',
          getter: (s) => s.showBrokenInequalities,
          onToggle: (ref) => ref
              .read(gameNotifierProvider.notifier)
              .toggleShowBrokenInequalities(),
        ),
        _PanelCheckbox(
          label: 'Show Wrong Moves',
          getter: (s) => s.showWrongMoves,
          onToggle: (ref) =>
              ref.read(gameNotifierProvider.notifier).toggleShowWrongMoves(),
        ),
        _PanelCheckbox(
          label: 'Auto Remove Pencil Marks',
          getter: (s) => s.autoRemovePencilMarks,
          onToggle: (ref) => ref
              .read(gameNotifierProvider.notifier)
              .toggleAutoRemovePencilMarks(),
        ),

        const _PanelDivider(),

        // ── Actions (2-column grid) ─────────────────────────────────
        const _SectionHeader('Actions'),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _PanelButton(
                label: 'Check',
                icon: Icons.check_circle_outline,
                colour: isWebEmbed ? kSiteTeal : const Color(0xFF4CAF50),
                onPressed: (context, ref) {
                  ref.read(gameNotifierProvider.notifier).checkSolution();
                  final board = ref.read(gameNotifierProvider).board;
                  if (board == null) return;
                  final errorCount = board.cells
                      .expand((r) => r)
                      .where((c) => c.isError)
                      .length;
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      content: Center(
                        heightFactor: 1,
                        child: board.isComplete
                            ? const GlyphLabel('All correct!', '🎉',
                                Icons.celebration_outlined,
                                leading: true, style: TextStyle(fontSize: 16))
                            : errorCount == 0
                                ? const GlyphLabel('No mistakes yet!', '✅',
                                    Icons.check_circle_outline,
                                    leading: true,
                                    style: TextStyle(fontSize: 16))
                                : GlyphLabel(
                                    '$errorCount cell${errorCount == 1 ? '' : 's'} to fix.',
                                    '❌',
                                    Icons.cancel_outlined,
                                    leading: true,
                                    style: const TextStyle(fontSize: 16)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _PanelButton(
                label: 'Save',
                icon: Icons.save_outlined,
                colour: isWebEmbed ? kSiteTeal : const Color(0xFF1976D2),
                onPressed: (context, ref) async {
                  await ref.read(gameNotifierProvider.notifier).saveGame();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Game saved!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _PanelButton(
                label: 'Reset',
                icon: Icons.refresh,
                colour: isWebEmbed ? kSiteNavy : const Color(0xFFF57C00),
                onPressed: (context, ref) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: const Text('Reset Puzzle?'),
                      content: const Text(
                        'This will clear all your progress. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isWebEmbed
                                ? kSiteNavy
                                : const Color(0xFFF57C00),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ref
                                .read(gameNotifierProvider.notifier)
                                .resetPuzzle();
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _PanelButton(
                label: 'Show Solution',
                icon: Icons.lightbulb_outline,
                colour: kSolutionAccent,
                onPressed: (context, ref) {
                  showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: const Text('Show the Solution?'),
                      content: const Text(
                        "The full solution will be filled in. "
                        "You won't be able to undo this.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSolutionAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ref.read(gameNotifierProvider.notifier).giveUp();
                          },
                          child: const Text('Show It'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        const _PanelDivider(),

        // ── Help ────────────────────────────────────────────────────
        const _SectionHeader('How to read the symbols'),
        const SizedBox(height: 6),
        _HelpSection(constraintStyle: constraintStyle),
        const SizedBox(height: 8),
      ],
    );

    return Container(
      color: Colors.white,
      child: scrollable
          ? SingleChildScrollView(padding: padding, child: content)
          : Padding(padding: padding, child: content),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: kPrimary,
      ),
    );
  }
}

class _PanelDivider extends StatelessWidget {
  const _PanelDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(color: Colors.grey.shade200),
    );
  }
}

class _PlaceModeOption extends ConsumerWidget {
  const _PlaceModeOption({required this.label, required this.value});
  final String label;
  final PlaceMode value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(gameNotifierProvider.select((s) => s.placeMode == value));
    return InkWell(
      onTap: () => ref.read(gameNotifierProvider.notifier).setPlaceMode(value),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? kPrimary : Colors.grey.shade400,
              size: 18,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label, style: const TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelCheckbox extends ConsumerWidget {
  const _PanelCheckbox({
    required this.label,
    required this.getter,
    required this.onToggle,
  });

  final String label;
  final bool Function(GameState) getter;
  final void Function(WidgetRef) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checked = ref.watch(gameNotifierProvider.select(getter));
    return InkWell(
      onTap: () => onToggle(ref),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: checked,
                onChanged: (_) => onToggle(ref),
                activeColor: kPrimary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelButton extends StatelessWidget {
  const _PanelButton({
    required this.label,
    required this.icon,
    required this.colour,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color colour;
  final void Function(BuildContext, WidgetRef) onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => SizedBox(
        width: double.infinity,
        height: 36,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colour,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          onPressed: () => onPressed(context, ref),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Help section with live symbol examples ────────────────────────────────────

class _HelpSection extends StatelessWidget {
  const _HelpSection({required this.constraintStyle});
  final ConstraintStyle constraintStyle;

  String get _rule => switch (constraintStyle) {
        ConstraintStyle.classic =>
          'The open side faces the bigger number; the tip points to the smaller.',
        ConstraintStyle.arrows =>
          'The tip always points to the smaller number.',
        ConstraintStyle.triangles =>
          'The tip always points to the smaller number.',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_rule,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        _ExampleRow(
          label: 'Horizontal:',
          examples: [
            _Example('5', PointDir.right, '2', '5 is bigger'),
            _Example('1', PointDir.left, '4', '4 is bigger'),
          ],
          style: constraintStyle,
        ),
        const SizedBox(height: 4),
        _ExampleRow(
          label: 'Vertical (between rows):',
          examples: [
            _Example('', PointDir.down, '', 'top is bigger'),
            _Example('', PointDir.up, '', 'bottom is bigger'),
          ],
          style: constraintStyle,
        ),
        const SizedBox(height: 6),
        const Text(
          '• Fill every row & column with numbers 1–N.\n'
          '• Each number appears exactly once per row and column.\n'
          '• Hint reveals one correct cell.',
          style: TextStyle(fontSize: 11, height: 1.5),
        ),
      ],
    );
  }
}

class _Example {
  const _Example(this.left, this.dir, this.right, this.meaning);
  final String left;
  final PointDir dir;
  final String right;
  final String meaning;
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({
    required this.label,
    required this.examples,
    required this.style,
  });
  final String label;
  final List<_Example> examples;
  final ConstraintStyle style;

  @override
  Widget build(BuildContext context) {
    final bold = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade800,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700)),
        const SizedBox(height: 2),
        for (final ex in examples)
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 1),
            child: Row(
              children: [
                if (ex.left.isNotEmpty) Text('${ex.left} ', style: bold),
                ConstraintSymbol(
                  dir: ex.dir,
                  style: style,
                  color: kConstraint,
                  size: 13,
                ),
                if (ex.right.isNotEmpty) Text(' ${ex.right}', style: bold),
                Flexible(
                  child: Text(
                    '   ${ex.meaning}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
