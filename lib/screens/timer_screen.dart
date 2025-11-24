// lib/screens/timer_screen.dart
import 'package:flutter/material.dart';
import 'package:intervalmaster/screens/timer_before_start.dart';
import 'package:intervalmaster/screens/timer_execution.dart';
import '../models/workout_config.dart';

class TimerScreen extends StatelessWidget {
  final WorkoutConfig config;

  const TimerScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return TimerExecution(config: config);
  }
}
