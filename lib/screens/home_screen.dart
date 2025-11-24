// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intervalmaster/models/workout_config.dart';
import 'package:intervalmaster/screens/timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Valores por defecto
  int preparationTime = 10;
  int exerciseTime = 20;
  int restBetweenExercises = 10;
  int restBetweenRounds = 30;
  int cycles = 8;
  int rounds = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _calculateTotalTime() {
    // Tiempo de un ciclo completo (ejercicio + descanso entre ejercicios)
    int timePerCycle = exerciseTime + restBetweenExercises;

    // Tiempo de una ronda completa (preparación + todos los ciclos)
    // Restamos un descanso porque después del último ejercicio no hay descanso
    int timePerRound = preparationTime + (timePerCycle * cycles) - restBetweenExercises;

    // Tiempo total: todas las rondas + descansos entre rondas
    // Restamos un descanso entre rondas porque después de la última ronda no hay descanso
    int totalTime = (timePerRound * rounds) + (restBetweenRounds * (rounds - 1));

    return totalTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildQuickStats(),
                    const SizedBox(height: 32),
                    _buildConfigurationCards(),
                    const SizedBox(height: 40),
                    _buildStartButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(
          Icons.timer_outlined,
          size: 64,
          color: Color(0xFF6C63FF),
        ),
        const SizedBox(height: 16),
        const Text(
          'Interval Master',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tu entrenamiento personalizado',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.6),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final totalTime = _calculateTotalTime();
    final minutes = totalTime ~/ 60;
    final seconds = totalTime % 60;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.fitness_center,
            value: '${cycles * rounds}',
            label: 'EJERCICIOS',
          ),
          Container(
            height: 50,
            width: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(
            icon: Icons.access_time,
            value: '${minutes}m ${seconds}s',
            label: 'DURACIÓN',
          ),
          Container(
            height: 50,
            width: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(
            icon: Icons.repeat,
            value: '$rounds',
            label: 'RONDAS',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildConfigurationCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'CONFIGURACIÓN',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB0B0C3),
              letterSpacing: 2,
            ),
          ),
        ),
        _buildTimeCard(
          title: 'Preparación',
          icon: Icons.play_circle_outline,
          color: const Color(0xFFFFA726),
          value: preparationTime,
          onChanged: (val) => setState(() => preparationTime = val.toInt()),
          min: 5,
          max: 30,
        ),
        const SizedBox(height: 16),
        _buildTimeCard(
          title: 'Ejercicio',
          icon: Icons.fitness_center,
          color: const Color(0xFF66BB6A),
          value: exerciseTime,
          onChanged: (val) => setState(() => exerciseTime = val.toInt()),
          min: 10,
          max: 60,
        ),
        const SizedBox(height: 16),
        _buildTimeCard(
          title: 'Descanso entre ejercicios',
          icon: Icons.self_improvement,
          color: const Color(0xFF42A5F5),
          value: restBetweenExercises,
          onChanged: (val) => setState(() => restBetweenExercises = val.toInt()),
          min: 5,
          max: 60,
        ),
        const SizedBox(height: 16),
        _buildTimeCard(
          title: 'Descanso entre rondas',
          icon: Icons.pause_circle_outline,
          color: const Color(0xFF29B6F6),
          value: restBetweenRounds,
          onChanged: (val) => setState(() => restBetweenRounds = val.toInt()),
          min: 10,
          max: 120,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildCountCard(
                title: 'Ciclos',
                icon: Icons.loop,
                color: const Color(0xFF9C27B0),
                value: cycles,
                onChanged: (val) => setState(() => cycles = val.toInt()),
                min: 1,
                max: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCountCard(
                title: 'Rondas',
                icon: Icons.repeat,
                color: const Color(0xFFEC407A),
                value: rounds,
                onChanged: (val) => setState(() => rounds = val.toInt()),
                min: 1,
                max: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeCard({
    required String title,
    required IconData icon,
    required Color color,
    required int value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '$value seg',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: Colors.white,
              overlayColor: color.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: value.toDouble(),
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountCard({
    required String title,
    required IconData icon,
    required Color color,
    required int value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFB0B0C3),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircularButton(
                icon: Icons.remove,
                onTap: () {
                  if (value > min) onChanged(value - 1);
                },
              ),
              const SizedBox(width: 12),
              _buildCircularButton(
                icon: Icons.add,
                onTap: () {
                  if (value < max) onChanged(value + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final config = WorkoutConfig(
              preparationTime: preparationTime,
              exerciseTime: exerciseTime,
              restBetweenExercises: restBetweenExercises,
              restBetweenRounds: restBetweenRounds,
              cycles: cycles,
              rounds: rounds,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerScreen(config: config),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                SizedBox(width: 8),
                Text(
                  'COMENZAR ENTRENAMIENTO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}