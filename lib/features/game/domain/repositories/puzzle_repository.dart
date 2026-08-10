import '../models/board.dart';
import '../models/game_state.dart';

abstract interface class PuzzleRepository {
  FutoshikiBoard generatePuzzle(int gridSize, Difficulty difficulty);
}
