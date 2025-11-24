// lib/models/workout_config.dart
class WorkoutConfig {
  final int preparationTime;
  final int exerciseTime;
  final int restBetweenExercises;
  final int restBetweenRounds;
  final int cycles;
  final int rounds;

  WorkoutConfig({
    required this.preparationTime,
    required this.exerciseTime,
    required this.restBetweenExercises,
    required this.restBetweenRounds,
    required this.cycles,
    required this.rounds,
  });
}
