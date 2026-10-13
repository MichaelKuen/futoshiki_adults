import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../game/domain/models/game_state.dart';
import '../../../game/presentation/pages/game_page.dart';
import '../../../game/presentation/providers/game_provider.dart';
import '../../../game/presentation/providers/settings_provider.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'privacy_policy_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void _startGame(Difficulty difficulty) {
    final size = ref.read(settingsNotifierProvider);
    unawaited(
      ref.read(gameNotifierProvider.notifier).startGame(size, difficulty),
    );
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const GamePage()),
    );
  }

  Future<void> _continueGame() async {
    final loaded =
        await ref.read(gameNotifierProvider.notifier).loadSavedGame();
    if (loaded && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const GamePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridSize = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Futoshiki for Adults'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // Animated emoji
              Center(
                child: const Text('⚖️', style: TextStyle(fontSize: 48))
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut),
              ),

              const SizedBox(height: 4),

              // Title
              Center(
                child: Text(
                  'Futoshiki for Adults',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 2),

              // Grid size indicator
              Center(
                child: Text(
                  'Grid: $gridSize×$gridSize  •  Tap ⚙ to change',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ),

              const SizedBox(height: 8),

              // How to play
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kSecondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How to play:',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    _RuleLine('Fill every box with a number from 1 to $gridSize'),
                    _RuleLine('Each row uses every number exactly once'),
                    _RuleLine('Each column uses every number exactly once'),
                    const _RuleLine('< means the LEFT box has a SMALLER number'),
                    const _RuleLine('∧ means the TOP box has a SMALLER number'),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Continue Game card (shown only when a save exists)
              ref.watch(hasSavedGameProvider).when(
                    data: (exists) {
                      if (!exists) return const SizedBox.shrink();
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: _continueGame,
                            child: Container(
                              width: double.infinity,
                              height: 62,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCF5FF),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: kSecondary, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Text('▶️',
                                      style: TextStyle(fontSize: 24)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Continue Game',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Resume where you left off',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey.shade400),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

              // Choose level
              Center(
                child: const Text(
                  'Choose your level:',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 8),

              _DifficultyButton(
                emoji: '⭐',
                label: 'Easy',
                subtitle: 'More numbers given — perfect for beginners!',
                colour: const Color(0xFFB5EAD7),
                onTap: () => _startGame(Difficulty.easy),
              ),

              const SizedBox(height: 8),

              _DifficultyButton(
                emoji: '⭐⭐',
                label: 'Medium',
                subtitle: 'Fewer numbers given — a tougher challenge!',
                colour: const Color(0xFFFFDAC1),
                onTap: () => _startGame(Difficulty.medium),
              ),

              const SizedBox(height: 8),

              _DifficultyButton(
                emoji: '⭐⭐⭐',
                label: 'Advanced',
                subtitle: 'Minimal clues given — serious challenge',
                colour: const Color(0xFFFFB3BA),
                onTap: () => _startGame(Difficulty.advanced),
              ),

              const SizedBox(height: 8),

              _DifficultyButton(
                emoji: '⭐⭐⭐⭐',
                label: 'Expert',
                subtitle: 'Very few clues — for puzzle veterans',
                colour: const Color(0xFFC3B1E1),
                onTap: () => _startGame(Difficulty.expert),
              ),

              const SizedBox(height: 8),

              _DifficultyButton(
                emoji: '💀',
                label: 'Insane',
                subtitle: 'Almost no clues — the ultimate test',
                colour: const Color(0xFFFF6B6B),
                onTap: () => _startGame(Difficulty.insane),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => const PrivacyPolicyPage()),
                  ),
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Rule line ─────────────────────────────────────────────────────────────────

class _RuleLine extends StatelessWidget {
  const _RuleLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 7, color: kPrimary),
          const SizedBox(width: 6),
          Flexible(
              child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

// ── Difficulty button ─────────────────────────────────────────────────────────

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.colour,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final String subtitle;
  final Color colour;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 2),
              color: Colors.grey.shade300,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade700)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
