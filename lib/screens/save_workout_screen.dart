import 'package:flutter/material.dart';
import 'package:intervalmaster/provider/workout_provider.dart';
import 'package:provider/provider.dart';
import 'add_workout_screen.dart';

class SavedWorkoutsScreen extends StatefulWidget {
  const SavedWorkoutsScreen({super.key});

  @override
  State<SavedWorkoutsScreen> createState() => _SavedWorkoutsScreenState();
}

class _SavedWorkoutsScreenState extends State<SavedWorkoutsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text("Entrenamientos guardados"),
        backgroundColor: const Color(0xFF1A1A2E),
      ),

      body: workoutProvider.workouts.isEmpty
          ? const Center(
        child: Text(
          "No hay entrenamientos guardados aún",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workoutProvider.workouts.length,
        itemBuilder: (context, index) {
          final w = workoutProvider.workouts[index];

          return Card(
            color: const Color(0xFF1A1A2E),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(
                w.name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Text(
                "Ciclos: ${w.cycles} | Rondas: ${w.rounds}",
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                // TODO: abrir detalles, editar, etc.
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWorkoutScreen(),
            ),
          );

          workoutProvider.loadWorkouts();
        },
      ),
    );
  }
}
