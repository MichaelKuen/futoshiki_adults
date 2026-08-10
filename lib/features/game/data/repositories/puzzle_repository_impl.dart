import '../../domain/logic/futoshiki_generator.dart';
import '../../domain/models/board.dart';
import '../../domain/models/game_state.dart';
import '../../domain/repositories/puzzle_repository.dart';

class PuzzleRepositoryImpl implements PuzzleRepository {
  final _generator = FutoshikiGenerator();

  @override
  FutoshikiBoard generatePuzzle(int gridSize, Difficulty difficulty) =>
      _generator.generate(gridSize, difficulty);
}
