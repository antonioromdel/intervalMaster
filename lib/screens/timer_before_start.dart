import 'package:flutter/material.dart';
import 'package:intervalmaster/models/workout_config.dart';

class TimerBeforeStart extends StatelessWidget {
  final WorkoutConfig config;

  const TimerBeforeStart({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrenamiento')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          Center(
            child: Text(
              'Preparación: ${config.preparation}s\n'
                  'Ejercicio: ${config.exercise}s\n'
                  'Descanso entre ejercicios: ${config.restBetweenExercises}s\n'
                  'Descanso entre rondas: ${config.restBetweenRounds}s\n'
                  'Ciclos: ${config.cycles}\n'
                  'Rondas: ${config.rounds}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Comenzar"))
        ],
      ),
    );
  }
}
