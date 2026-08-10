// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$puzzleRepositoryHash() => r'e35e424a8c3b73e9f1215fa668c090d109772184';

/// See also [puzzleRepository].
@ProviderFor(puzzleRepository)
final puzzleRepositoryProvider = AutoDisposeProvider<PuzzleRepository>.internal(
  puzzleRepository,
  name: r'puzzleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$puzzleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PuzzleRepositoryRef = AutoDisposeProviderRef<PuzzleRepository>;
String _$hasSavedGameHash() => r'f3a56f7b4a06da7b510530fb2956cac2f9e7e890';

/// See also [hasSavedGame].
@ProviderFor(hasSavedGame)
final hasSavedGameProvider = AutoDisposeFutureProvider<bool>.internal(
  hasSavedGame,
  name: r'hasSavedGameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hasSavedGameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasSavedGameRef = AutoDisposeFutureProviderRef<bool>;
String _$gameNotifierHash() => r'2f26ce28dee207d40c86a2717f7f84d2ef773b2b';

/// See also [GameNotifier].
@ProviderFor(GameNotifier)
final gameNotifierProvider = NotifierProvider<GameNotifier, GameState>.internal(
  GameNotifier.new,
  name: r'gameNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameNotifier = Notifier<GameState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
