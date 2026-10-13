import 'dart:async';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

enum ConstraintStyle { classic, arrows, triangles }

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  static const _gridSizeKey = 'grid_size';

  @override
  int build() {
    unawaited(_loadGridSize());
    return 5;
  }

  /// The stored grid size, for starting a game before this provider has
  /// finished loading (web auto-start).
  static Future<int> savedGridSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_gridSizeKey) ?? 5;
  }

  Future<void> _loadGridSize() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_gridSizeKey) ?? 5;
    state = saved;
  }

  Future<void> setGridSize(int size) async {
    assert(size == 5 || size == 6 || size == 7);
    state = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_gridSizeKey, size);
  }
}

@Riverpod(keepAlive: true)
class ConstraintStyleNotifier extends _$ConstraintStyleNotifier {
  static const _key = 'constraint_style';

  @override
  ConstraintStyle build() {
    unawaited(_load());
    return ConstraintStyle.classic;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    if (name == null) return;
    final style =
        ConstraintStyle.values.firstWhereOrNull((e) => e.name == name);
    if (style != null) state = style;
  }

  Future<void> setStyle(ConstraintStyle style) async {
    state = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, style.name);
  }
}
