import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import 'constraint_symbol.dart';

/// Web replacement for the Home and Settings pages: pick level, grid size
/// and symbol style, then start. Scaled to fit; never scrolls.
Future<void> showNewGameDialog(BuildContext context, {bool canCancel = true}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: canCancel,
    builder: (_) => _NewGameDialog(canCancel: canCancel),
  );
}

class _NewGameDialog extends ConsumerStatefulWidget {
  const _NewGameDialog({required this.canCancel});
  final bool canCancel;

  @override
  ConsumerState<_NewGameDialog> createState() => _NewGameDialogState();
}

class _NewGameDialogState extends ConsumerState<_NewGameDialog> {
  late Difficulty _difficulty = ref.read(gameNotifierProvider).difficulty;
  late int _size = ref.read(settingsNotifierProvider);
  late ConstraintStyle _style = ref.read(constraintStyleNotifierProvider);

  static const _labels = {
    Difficulty.easy: 'Easy',
    Difficulty.medium: 'Medium',
    Difficulty.advanced: 'Advanced',
    Difficulty.expert: 'Expert',
    Difficulty.insane: 'Insane',
  };

  void _start() {
    ref.read(settingsNotifierProvider.notifier).setGridSize(_size);
    ref.read(constraintStyleNotifierProvider.notifier).setStyle(_style);
    ref.read(gameNotifierProvider.notifier).startGame(_size, _difficulty);
    Navigator.pop(context);
  }

  Widget _section(String title, List<Widget> chips) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: chips),
          const SizedBox(height: 14),
        ],
      );

  Widget _chip(Widget label, bool selected, VoidCallback onTap) => ChoiceChip(
        label: label,
        selected: selected,
        onSelected: (_) => setState(onTap),
        showCheckmark: false,
        selectedColor: kSecondary.withValues(alpha: 0.6),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Game',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            _section('Level', [
              for (final d in Difficulty.values)
                _chip(
                    Text(_labels[d]!), _difficulty == d, () => _difficulty = d),
            ]),
            _section('Grid size', [
              for (final n in const [5, 6, 7])
                _chip(Text('$n × $n'), _size == n, () => _size = n),
            ]),
            _section('Symbols', [
              for (final st in ConstraintStyle.values)
                _chip(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final d in const [PointDir.left, PointDir.up])
                        ConstraintSymbol(
                            dir: d, style: st, color: kConstraint, size: 14),
                    ],
                  ),
                  _style == st,
                  () => _style = st,
                ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.canCancel)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _start, child: const Text('Start')),
              ],
            ),
          ],
        ),
      ),
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, c) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300, maxHeight: c.maxHeight),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            child: content,
          ),
        ),
      ),
    );
  }
}
