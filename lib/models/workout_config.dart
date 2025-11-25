class WorkoutConfig {
  int? id;
  final String name;
  final int preparation;
  final int exercise;
  final int restBetweenExercises;
  final int restBetweenRounds;
  final int cycles;
  final int rounds;

  WorkoutConfig({
    this.id,
    required this.name,
    required this.preparation,
    required this.exercise,
    required this.restBetweenExercises,
    required this.restBetweenRounds,
    required this.cycles,
    required this.rounds,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'preparation': preparation,
      'exercise': exercise,
      'restBetweenExercises': restBetweenExercises,
      'restBetweenRounds': restBetweenRounds,
      'cycles': cycles,
      'rounds': rounds,
    };
  }

  factory WorkoutConfig.fromMap(Map<String, dynamic> map) {
    return WorkoutConfig(
      id: map['id'],
      name: map['name'],
      preparation: map['preparation'],
      exercise: map['exercise'],
      restBetweenExercises: map['restBetweenExercises'],
      restBetweenRounds: map['restBetweenRounds'],
      cycles: map['cycles'],
      rounds: map['rounds'],
    );
  }
}
