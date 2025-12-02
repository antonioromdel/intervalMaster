import 'package:audioplayers/audioplayers.dart';

class Sounds {
  final String countSound = 'sounds/beep.mp3';
  final String startSound = 'sounds/start_exercise.mp3';
  final String finishSound = 'sounds/finish_exercise.mp3';
  final String finishTraining = 'sounds/training_end.mp3';
  final AudioPlayer _player = AudioPlayer();

  Future<void> playCount() async {
    await _player.play(AssetSource(countSound));
  }

  Future<void> playStart() async {
    await _player.play(AssetSource(startSound));
  }

  Future<void> playFinishExercise() async{
    await _player.play(AssetSource(finishSound));
  }

  Future<void> playFinish() async {
    await _player.play(AssetSource(finishTraining));
  }

  void disposeSounds(){
    _player.dispose();
  }
}