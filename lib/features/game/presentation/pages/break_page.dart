import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/game_provider.dart';

class BreakPage extends ConsumerWidget {
  const BreakPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3CD),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('😊', style: TextStyle(fontSize: 100))
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.08, 1.08),
                        duration: 1200.ms,
                        curve: Curves.easeInOut,
                      ),

                  const SizedBox(height: 32),

                  const Text(
                    'Break Time!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE67E22),
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 20),

                  const Text(
                    "You've been playing for 10 minutes.\n\n"
                    "Time to rest your eyes! 👀\n\n"
                    "Stretch, drink some water,\nand come back when you're ready! 😄",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF555555),
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 56),

                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(gameNotifierProvider.notifier)
                          .acknowledgeBreak();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(240, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("I'm Ready! ▶"),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .moveY(begin: 20, end: 0, duration: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
