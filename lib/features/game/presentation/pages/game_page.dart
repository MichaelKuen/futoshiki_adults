import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/game_state.dart';
import '../providers/game_provider.dart';
import '../widgets/digit_pad.dart';
import '../widgets/futoshiki_grid.dart';
import '../widgets/game_panel.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showWinDialog(int elapsedSeconds) {
    final formattedTime = _formatTime(elapsedSeconds);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 80))
                .animate()
                .scale(duration: 700.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(
              'Brilliant Work! 🎉',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 8),
            Text(
              'You solved the Futoshiki!',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 6),
            Text(
              'Time: $formattedTime',
              style: const TextStyle(fontSize: 15),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Play Again! ▶',
                style: TextStyle(fontSize: 18),
              ),
            ).animate().fadeIn(delay: 800.ms),
          ),
        ],
      ),
    );
  }

  ConfettiWidget _buildConfetti() => ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 28,
        minBlastForce: 10,
        emissionFrequency: 0.05,
        numberOfParticles: 45,
        gravity: 0.12,
        colors: const [
          Colors.pink,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.teal,
          Colors.red,
        ],
      );

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);
    final isWideScreen = MediaQuery.of(context).size.width >= 700;

    ref.listen<GameState>(gameNotifierProvider, (previous, next) {
      if (previous?.status != GameStatus.won &&
          next.status == GameStatus.won) {
        _confettiController.play();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showWinDialog(next.elapsedSeconds);
        });
      }
    });

    final gameContent = SafeArea(
      child: Column(
        children: [
          _StatsBar(state: gameState),
          if (gameState.placeMode == PlaceMode.pencilMarks)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: kPrimary.withValues(alpha: 0.15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: kPrimary),
                  const SizedBox(width: 6),
                  Text(
                    'Pencil Mark Mode',
                    style: TextStyle(
                      fontSize: 13,
                      color: kPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 380,
                    maxHeight: 380,
                  ),
                  child: const FutoshikiGrid(),
                ),
              ),
            ),
          ),
          if (gameState.status == GameStatus.gaveUp) ...[
            const SizedBox(height: 8),
            _GaveUpBanner(),
            const SizedBox(height: 16),
          ] else ...[
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DigitPad(),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ActionRow(),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );

    if (isWideScreen) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Futoshiki for Adults ⚖️'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: gameContent),
                Container(
                  width: 270,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: Colors.grey.shade200, width: 1),
                    ),
                  ),
                  child: const GamePanel(),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildConfetti(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Futoshiki for Adults ⚖️'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Game menu',
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const Drawer(
        width: 280,
        child: SafeArea(child: GamePanel()),
      ),
      body: Stack(
        children: [
          gameContent,
          Align(
            alignment: Alignment.topCenter,
            child: _buildConfetti(),
          ),
        ],
      ),
    );
  }
}

// ── Stats bar ─────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.state});

  final GameState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimary.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 20, color: kPrimary),
              const SizedBox(width: 6),
              Text(
                _formatTime(state.elapsedSeconds),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Mistakes: ', style: TextStyle(fontSize: 16)),
              Text(
                '${state.mistakes}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatTime(int s) =>
    '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

// ── Gave-up banner ────────────────────────────────────────────────────────────

class _GaveUpBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF9C27B0), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '💡 Solution revealed',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Study the board above, then start a new game when ready.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Play Again ▶',
                  style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
