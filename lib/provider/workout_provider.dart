import 'package:flutter/material.dart';
import 'package:intervalmaster/helpers/sqflite/workout_storage.dart';
import 'package:intervalmaster/models/workout_config.dart';

class WorkoutProvider extends ChangeNotifier {
  List<WorkoutConfig> workouts = [];

  Future<void> loadWorkouts() async {
    workouts = await WorkoutStorage.getWorkouts();
    notifyListeners();
  }

  Future<void> addWorkout(WorkoutConfig workout) async {
    await WorkoutStorage.saveWorkout(workout);
    await loadWorkouts();
  }

  Future<void> updateWorkout(WorkoutConfig workout) async {
    await WorkoutStorage.updateWorkout(workout);
    await loadWorkouts();
  }

  Future<void> deleteWorkout(int id) async {
    await WorkoutStorage.deleteWorkoutById(id);
    await loadWorkouts();
  }
}