import 'package:flutter/material.dart';
import 'package:intervalmaster/helpers/sqflite/workout_storage.dart';
import 'package:intervalmaster/models/workout_config.dart';
import 'package:intervalmaster/provider/workout_provider.dart';
import 'package:provider/provider.dart';

class AddWorkoutScreen extends StatefulWidget {
  final WorkoutConfig? workoutToEdit;

  const AddWorkoutScreen({super.key, this.workoutToEdit});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final TextEditingController nameController = TextEditingController();
  int preparationTime = 10;
  int exerciseTime = 20;
  int restBetweenExercises = 10;
  int restBetweenRounds = 30;
  int cycles = 8;
  int rounds = 1;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    // Si hay un entrenamiento para editar, cargar sus valores
    if (widget.workoutToEdit != null) {
      _isEditing = true;
      final workout = widget.workoutToEdit!;
      nameController.text = workout.name;
      preparationTime = workout.preparation;
      exerciseTime = workout.exercise;
      restBetweenExercises = workout.restBetweenExercises;
      restBetweenRounds = workout.restBetweenRounds;
      cycles = workout.cycles;
      rounds = workout.rounds;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: Text(_isEditing ? "Editar entrenamiento" : "Nuevo entrenamiento"),
        backgroundColor: const Color(0xFF1A1A2E),
        actions: _isEditing
            ? [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context),
          ),
        ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Nombre del entrenamiento",
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSlider("Preparación", preparationTime, 5, 30, (v) => setState(() => preparationTime = v)),
            _buildSlider("Ejercicio", exerciseTime, 10, 60, (v) => setState(() => exerciseTime = v)),
            _buildSlider("Descanso entre ejercicios", restBetweenExercises, 5, 60, (v) => setState(() => restBetweenExercises = v)),
            _buildSlider("Descanso entre rondas", restBetweenRounds, 10, 120, (v) => setState(() => restBetweenRounds = v)),
            _buildSlider("Ciclos", cycles, 1, 20, (v) => setState(() => cycles = v)),
            _buildSlider("Rondas", rounds, 1, 10, (v) => setState(() => rounds = v)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("El nombre del entrenamiento no puede estar vacío"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final workout = WorkoutConfig(
                  id: _isEditing ? widget.workoutToEdit!.id : null,
                  name: nameController.text,
                  preparation: preparationTime,
                  exercise: exerciseTime,
                  restBetweenExercises: restBetweenExercises,
                  restBetweenRounds: restBetweenRounds,
                  cycles: cycles,
                  rounds: rounds,
                );

                final provider = Provider.of<WorkoutProvider>(context, listen: false);

                if (_isEditing) {
                  await provider.updateWorkout(workout);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Entrenamiento actualizado"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  await provider.addWorkout(workout);
                }

                Navigator.pop(context);
              },
              child: Text(_isEditing ? "Actualizar entrenamiento" : "Guardar entrenamiento"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar entrenamiento'),
        content: const Text('¿Estás seguro de que quieres eliminar este entrenamiento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final provider = Provider.of<WorkoutProvider>(context, listen: false);
              await provider.deleteWorkout(widget.workoutToEdit!.id!);
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Volver a la lista
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Entrenamiento eliminado"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String title, int value, int min, int max, Function(int) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          activeColor: const Color(0xFF6C63FF),
          onChanged: (v) => onChange(v.toInt()),
        ),
        Text("$value", style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
      ],
    );
  }
}