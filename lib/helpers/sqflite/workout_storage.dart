import 'dart:convert';
import 'package:intervalmaster/models/workout_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutStorage {
  static const String key = "workouts";

  static Future<List<WorkoutConfig>> getWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    return list.map((e) {
      final map = jsonDecode(e);
      return WorkoutConfig.fromMap(map);
    }).toList();
  }

  static Future<void> saveWorkout(WorkoutConfig workout) async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = await getWorkouts();

    if (workout.id == null) {
      int maxId = workouts.isEmpty ? 0 : workouts.map((w) => w.id!).reduce((a, b) => a > b ? a : b);
      workout.id = maxId + 1;
    }

    workouts.add(workout);
    final encoded = workouts.map((w) => jsonEncode(w.toMap())).toList();
    await prefs.setStringList(key, encoded);
  }

  static Future<void> deleteWorkoutById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final workouts = await getWorkouts();
    workouts.removeWhere((w) => w.id == id);
    final encoded = workouts.map((w) => jsonEncode(w.toMap())).toList();
    await prefs.setStringList(key, encoded);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}



