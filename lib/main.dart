import 'package:flutter/material.dart';
import 'package:intervalmaster/provider/workout_provider.dart';
import 'package:intervalmaster/screens/home_screen.dart';
import 'package:intervalmaster/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interval Master',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}


