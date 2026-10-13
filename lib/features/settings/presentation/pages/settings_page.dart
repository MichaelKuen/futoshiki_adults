import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../game/presentation/providers/settings_provider.dart';
import '../../../game/presentation/widgets/constraint_symbol.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Grid Size section ───────────────────────────────────────
              Text(
                'Grid Size',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'A larger grid means more numbers and more challenge. '
                'Start with 5×5 if you are new to Futoshiki!',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              _GridSizeCard(
                size: 5,
                label: '5 × 5',
                subtitle: 'Numbers 1 – 5 · Best for beginners',
                emoji: '⭐',
                colour: const Color(0xFFBAFFC9),
              ),

              const SizedBox(height: 14),

              _GridSizeCard(
                size: 6,
                label: '6 × 6',
                subtitle: 'Numbers 1 – 6 · A bigger challenge',
                emoji: '⭐⭐',
                colour: const Color(0xFFFFDAC1),
              ),

              const SizedBox(height: 14),

              _GridSizeCard(
                size: 7,
                label: '7 × 7',
                subtitle: 'Numbers 1 – 7 · For puzzle experts!',
                emoji: '⭐⭐⭐',
                colour: const Color(0xFFE8BAFF),
              ),

              const SizedBox(height: 40),

              // ── Constraint Style section ─────────────────────────────────
              Text(
                'Inequality Symbols',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Choose how the inequality signs look between cells. '
                'For arrows and triangles, the tip always points to the smaller number.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              _ConstraintStyleCard(
                style: ConstraintStyle.classic,
                label: 'Classic',
                description: 'Traditional maths symbols',
                colour: const Color(0xFFE3F2FD),
              ),

              const SizedBox(height: 14),

              _ConstraintStyleCard(
                style: ConstraintStyle.arrows,
                label: 'Arrows',
                description: 'Tip points to the smaller number',
                colour: const Color(0xFFE8F5E9),
              ),

              const SizedBox(height: 14),

              _ConstraintStyleCard(
                style: ConstraintStyle.triangles,
                label: 'Triangles',
                description: 'Tip points to the smaller number',
                colour: const Color(0xFFFFF9C4),
              ),

              const SizedBox(height: 40),

              // ── About section ────────────────────────────────────────────
              Text(
                'About',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Futoshiki for Adults\nVersion 1.0.0\n\n'
                'A challenging inequality puzzle for adults — no ads, no data collected, '
                'just pure puzzle satisfaction!',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Grid Size Card ────────────────────────────────────────────────────────────

class _GridSizeCard extends ConsumerWidget {
  const _GridSizeCard({
    required this.size,
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.colour,
  });

  final int size;
  final String label;
  final String subtitle;
  final String emoji;
  final Color colour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(settingsNotifierProvider) == size;

    return GestureDetector(
      onTap: () {
        ref.read(settingsNotifierProvider.notifier).setGridSize(size);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Grid size set to $size×$size! Starts from your next game.',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colour : colour.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? kPrimary : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: kPrimary, size: 28),
          ],
        ),
      ),
    );
  }
}

// ── Constraint Style Card ─────────────────────────────────────────────────────

class _ConstraintStyleCard extends ConsumerWidget {
  const _ConstraintStyleCard({
    required this.style,
    required this.label,
    required this.description,
    required this.colour,
  });

  final ConstraintStyle style;
  final String label;
  final String description;
  final Color colour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(constraintStyleNotifierProvider) == style;

    return GestureDetector(
      onTap: () =>
          ref.read(constraintStyleNotifierProvider.notifier).setStyle(style),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colour : colour.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? kPrimary : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Symbol preview box
            SizedBox(
              width: 52,
              child: Column(
                children: [
                  for (final pair in const [
                    [PointDir.left, PointDir.right],
                    [PointDir.up, PointDir.down],
                  ])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final d in pair)
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: ConstraintSymbol(
                              dir: d,
                              style: style,
                              color: kConstraint,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: kPrimary, size: 28),
          ],
        ),
      ),
    );
  }
}
