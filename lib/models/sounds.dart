import 'package:audioplayers/audioplayers.dart';

class Sounds {
  final String countSound = 'sounds/beep.mp3';
  final String startSound = 'sounds/start_training.mp3';
  final String finishSound = 'sounds/training_end.mp3';
  final AudioPlayer _player = AudioPlayer();

  Future<void> playCount() async {
    await _player.play(AssetSource(countSound));
  }

  Future<void> playStart() async {
    await _player.play(AssetSource(startSound));
  }

  Future<void> playFinish() async {
    await _player.play(AssetSource(finishSound));
  }

  void disposeSounds(){
    _player.dispose();
  }
}