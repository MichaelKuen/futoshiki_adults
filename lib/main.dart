import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/platform.dart';
import 'core/theme/app_theme.dart';
import 'features/game/presentation/pages/game_page.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Nunito'], license);
  });
  runApp(const ProviderScope(child: FutoshikiApp()));
}

class FutoshikiApp extends StatelessWidget {
  const FutoshikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futoshiki for Adults',
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      // Web: straight into a game inside the site's iframe.
      home: isWebEmbed ? const GamePage(autoStart: true) : const HomePage(),
    );
  }
}
