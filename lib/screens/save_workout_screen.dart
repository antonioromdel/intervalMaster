import 'package:flutter/material.dart';
import 'add_workout_screen.dart';

class SavedWorkoutsScreen extends StatelessWidget {
  const SavedWorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text("Entrenamientos guardados"),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: const Center(
        child: Text(
          "No hay entrenamientos guardados aún",
          style: TextStyle(color: Colors.white70),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWorkoutScreen(),
            ),
          );
        },
      ),
    );
  }
}
