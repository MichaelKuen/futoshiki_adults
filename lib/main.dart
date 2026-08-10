import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FutoshikiApp()));
}

class FutoshikiApp extends StatelessWidget {
  const FutoshikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futoshiki for Kids',
      theme: kidsTheme,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
