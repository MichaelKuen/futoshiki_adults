import 'dart:async';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/platform.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glyph.dart';
import '../../domain/models/game_state.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/digit_pad.dart';
import '../widgets/futoshiki_grid.dart';
import '../widgets/game_panel.dart';
import '../widgets/new_game_dialog.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key, this.autoStart = false});

  /// Web opens straight into a game (there is no Home page).
  final bool autoStart;

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  late ConfettiController _confettiController;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _lifecycle = AppLifecycleListener(
      onHide: () {
        ref.read(gameNotifierProvider.notifier).setPaused(true);
        if (isWebEmbed) _autoSaveNow();
      },
      onShow: () => ref.read(gameNotifierProvider.notifier).setPaused(false),
    );
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _autoStart());
    }
    // Global handler, not a focus-based KeyboardListener, so keys keep
    // working after the player clicks a button.
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  static final _digitKeys = <LogicalKeyboardKey, int>{
    LogicalKeyboardKey.digit1: 1,
    LogicalKeyboardKey.digit2: 2,
    LogicalKeyboardKey.digit3: 3,
    LogicalKeyboardKey.digit4: 4,
    LogicalKeyboardKey.digit5: 5,
    LogicalKeyboardKey.digit6: 6,
    LogicalKeyboardKey.digit7: 7,
    LogicalKeyboardKey.numpad1: 1,
    LogicalKeyboardKey.numpad2: 2,
    LogicalKeyboardKey.numpad3: 3,
    LogicalKeyboardKey.numpad4: 4,
    LogicalKeyboardKey.numpad5: 5,
    LogicalKeyboardKey.numpad6: 6,
    LogicalKeyboardKey.numpad7: 7,
  };

  static final _eraseKeys = {
    LogicalKeyboardKey.backspace,
    LogicalKeyboardKey.delete,
    LogicalKeyboardKey.digit0,
    LogicalKeyboardKey.numpad0,
  };

  static final _arrows = <LogicalKeyboardKey, (int, int)>{
    LogicalKeyboardKey.arrowUp: (-1, 0),
    LogicalKeyboardKey.arrowDown: (1, 0),
    LogicalKeyboardKey.arrowLeft: (0, -1),
    LogicalKeyboardKey.arrowRight: (0, 1),
  };

  /// Returns true for keys the game handled.
  bool _onKey(KeyEvent event) {
    if (event is KeyUpEvent || !mounted) return false;
    // Ignore keys while a dialog (New Game, Options, win...) is open.
    if (ModalRoute.of(context)?.isCurrent != true) return false;
    final state = ref.read(gameNotifierProvider);
    final board = state.board;
    if (board == null || state.status != GameStatus.playing) return false;
    final n = ref.read(gameNotifierProvider.notifier);
    final key = event.logicalKey;

    final move = _arrows[key];
    if (move != null) {
      n.moveSelection(move.$1, move.$2);
      return true;
    }
    if (event is KeyRepeatEvent) return false;

    final digit = _digitKeys[key];
    if (digit != null) {
      if (digit > board.size) return false;
      n.inputDigit(digit);
      return true;
    }
    if (_eraseKeys.contains(key)) {
      n.eraseCell();
      return true;
    }
    if (key == LogicalKeyboardKey.keyN) {
      n.setPlaceMode(state.placeMode == PlaceMode.pencilMarks
          ? PlaceMode.solution
          : PlaceMode.pencilMarks);
      return true;
    }
    if (key == LogicalKeyboardKey.keyH) {
      n.useHint();
      return true;
    }
    return false;
  }

  Future<void> _autoStart() async {
    final notifier = ref.read(gameNotifierProvider.notifier);
    // Web resumes the auto-saved game, if any.
    if (await notifier.loadSavedGame()) return;
    final size = await SettingsNotifier.savedGridSize();
    if (!mounted) return;
    await notifier.startGame(size, Difficulty.medium);
  }

  // ── Web auto-save (browser localStorage via shared_preferences) ──────────

  Timer? _autoSaveTimer;

  /// Saves at most every couple of seconds (the clock changes the state
  /// every second, so a debounce would never fire).
  void _scheduleAutoSave() {
    _autoSaveTimer ??= Timer(const Duration(seconds: 2), _autoSaveNow);
  }

  void _autoSaveNow() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
    final state = ref.read(gameNotifierProvider);
    if (state.status == GameStatus.playing && state.board != null) {
      unawaited(ref.read(gameNotifierProvider.notifier).saveGame());
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _autoSaveTimer?.cancel();
    _lifecycle.dispose();
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
            Glyph('🏆', Icons.emoji_events, size: 80, color: kSecondary)
                .animate()
                .scale(duration: 700.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            GlyphLabel(
              'Brilliant Work!',
              '🎉',
              Icons.celebration_outlined,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isWebEmbed ? kSiteTeal : Colors.green.shade700,
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
                if (isWebEmbed) {
                  showNewGameDialog(context);
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: GlyphLabel(
                isWebEmbed ? 'New Game' : 'Play Again!',
                '▶',
                Icons.play_arrow,
                style: const TextStyle(fontSize: 18),
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
    ref.listen<GameState>(gameNotifierProvider, (previous, next) {
      if (previous?.status != GameStatus.won && next.status == GameStatus.won) {
        _confettiController.play();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showWinDialog(next.elapsedSeconds);
        });
      }
      if (isWebEmbed) {
        if (next.status == GameStatus.playing) {
          _scheduleAutoSave();
        } else if (next.status == GameStatus.gaveUp &&
            previous?.status != GameStatus.gaveUp) {
          // A revealed puzzle shouldn't come back on the next visit.
          unawaited(ref.read(gameNotifierProvider.notifier).clearSavedGame());
        }
      }
    });

    final body = Stack(
      children: [
        SafeArea(
          child: LayoutBuilder(
            builder: (context, c) => _GameLayout(
              width: c.maxWidth,
              height: c.maxHeight,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildConfetti(),
        ),
      ],
    );

    // The website shows the title, rules and links around the iframe.
    if (isWebEmbed) return Scaffold(body: body);

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
      body: body,
    );
  }
}

// ── Layout ────────────────────────────────────────────────────────────────────

/// Sizes everything from the space the game actually gets (the iframe on web,
/// the body below the app bar on mobile) so nothing overflows or scrolls.
///
/// Side panel only when there is room for it (>= 720 wide and landscape);
/// otherwise controls stack under the board.
class _GameLayout extends ConsumerWidget {
  const _GameLayout({required this.width, required this.height});

  final double width;
  final double height;

  static const double _pad = 12;
  static const double _gap = 8;
  static const double _maxBoard = 600;

  /// Below this the inline side panel would be too small to read, so an
  /// Options button opens it in a dialog instead.
  static const double _minInlinePanelHeight = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    final gaveUp = state.status == GameStatus.gaveUp;

    final statsH = (height * 0.065).clamp(32.0, 44.0);
    final padH = (height * 0.085).clamp(36.0, 60.0);
    final actionH = (height * 0.07).clamp(34.0, 52.0);
    final controlsH = padH + _gap + actionH;

    final notifier = ref.read(gameNotifierProvider.notifier);
    final notesOn = state.placeMode == PlaceMode.pencilMarks;

    /// Web has no app bar, so Notes, New Game and Options live in the
    /// controls. [withOptions] is false when the side panel is inline.
    List<Widget> webButtons({required bool withOptions}) => [
          ActionButton(
            label: 'Notes',
            emoji: '✏️',
            icon: Icons.edit_outlined,
            height: actionH,
            selected: notesOn,
            onPressed: () => notifier.setPlaceMode(
                notesOn ? PlaceMode.solution : PlaceMode.pencilMarks),
          ),
          ActionButton(
            label: 'New',
            emoji: '➕',
            icon: Icons.add,
            height: actionH,
            onPressed: () => showNewGameDialog(context),
          ),
          if (withOptions)
            ActionButton(
              label: 'Options',
              emoji: '⚙️',
              icon: Icons.tune,
              height: actionH,
              onPressed: () => showGamePanelDialog(context),
            ),
        ];

    Widget controls(double w, {required bool withOptions}) => SizedBox(
          width: w,
          height: controlsH,
          child: gaveUp
              ? const _GaveUpBanner()
              : Column(
                  children: [
                    DigitPad(height: padH),
                    const SizedBox(height: _gap),
                    ActionRow(
                      height: actionH,
                      extra: isWebEmbed
                          ? webButtons(withOptions: withOptions)
                          : const [],
                    ),
                  ],
                ),
        );

    final side = width >= 720 && width > height;

    if (!side) {
      final board = math.min(
        math.min(width - 2 * _pad, _maxBoard),
        height - statsH - controlsH - 2 * _gap - _pad,
      );
      return Column(
        children: [
          _StatsBar(state: state, height: statsH),
          Expanded(child: Center(child: FutoshikiGrid(size: board))),
          controls(width - 2 * _pad, withOptions: true),
          const SizedBox(height: _pad),
        ],
      );
    }

    final panelW = (width * 0.3).clamp(260.0, 320.0);
    final leftW = width - panelW;
    final board = math.min(
      math.min(leftW - 2 * _pad, _maxBoard),
      height - statsH - 2 * _pad,
    );
    final innerW = panelW - 2 * _pad;
    final panelSpace = height - 2 * _pad - controlsH - _gap;
    final panelInline = panelSpace >= _minInlinePanelHeight;

    return Row(
      children: [
        SizedBox(
          width: leftW,
          child: Column(
            children: [
              _StatsBar(state: state, height: statsH),
              Expanded(child: Center(child: FutoshikiGrid(size: board))),
            ],
          ),
        ),
        Container(
          width: panelW,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          padding: const EdgeInsets.all(_pad),
          child: Column(
            children: [
              controls(innerW, withOptions: false),
              const SizedBox(height: _gap),
              Expanded(
                child: panelInline
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        // Laid out at its natural width, then scaled to fit.
                        child: const SizedBox(
                          width: 280,
                          child: GamePanel(scrollable: false),
                        ),
                      )
                    : Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: actionH,
                          child: ActionButton(
                            label: 'Options',
                            emoji: '⚙️',
                            icon: Icons.tune,
                            height: actionH,
                            onPressed: () => showGamePanelDialog(context),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows the game panel in a dialog, scaled to fit (never scrolls).
Future<void> showGamePanelDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (ctx, c) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 320, maxHeight: c.maxHeight),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const GamePanel(scrollable: false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

// ── Stats bar ─────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.state, required this.height});

  final GameState state;
  final double height;

  @override
  Widget build(BuildContext context) {
    final big = TextStyle(
      fontSize: height * 0.42,
      fontWeight: FontWeight.bold,
    );
    return Container(
      height: height,
      color: kPrimary.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Icon(Icons.timer_outlined,
                      size: height * 0.48, color: kPrimary),
                  const SizedBox(width: 6),
                  Text(_formatTime(state.elapsedSeconds), style: big),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (state.placeMode == PlaceMode.pencilMarks)
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined,
                        size: height * 0.4, color: kPrimary),
                    const SizedBox(width: 4),
                    Text(
                      'Notes on',
                      style: TextStyle(
                        fontSize: height * 0.34,
                        color: kPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const Spacer(),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Text('Mistakes: ', style: TextStyle(fontSize: height * 0.36)),
                  Text('${state.mistakes}',
                      style: big.copyWith(color: kPrimary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTime(int s) =>
    '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

// ── Gave-up banner ────────────────────────────────────────────────────────────

/// Replaces the digit pad after Show Solution; fills the same space.
class _GaveUpBanner extends StatelessWidget {
  const _GaveUpBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kSolutionBanner,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSolutionAccent, width: 1.5),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GlyphLabel(
              'Solution revealed',
              '💡',
              Icons.lightbulb_outline,
              leading: true,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => isWebEmbed
                  ? showNewGameDialog(context)
                  : Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kSolutionAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: GlyphLabel(
                  isWebEmbed ? 'New Game' : 'Play Again', '▶', Icons.play_arrow,
                  style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
