import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/rendering.dart';
import 'package:vibration/vibration.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _canVibrate = false;

  Future<void> initialize() async {
    _canVibrate = await Vibration.hasVibrator();

    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    debugPrint('FeedbackService initialized - Can vibrate: $_canVibrate');
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setHapticEnabled(bool enabled) {
    _hapticEnabled = enabled;
  }

  Future<void> _playSound(String soundPath) async {
    if (!_soundEnabled) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      debugPrint('Error paying sound: $e');
    }
  }

  Future<void> _vibrate({int duration = 50, int amplitude = 120}) async {
    if (!_hapticEnabled || !_canVibrate) return;

    try {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    } catch (e) {
      debugPrint('Error vibrating: $e');
    }
  }

  Future<void> onCorrectMatch() async {
    await Future.wait([
      _playSound('sounds/correct.mp3'),
      _vibrate(duration: 100, amplitude: 200),
    ]);
  }

  Future<void> onWrongMatch() async {
    await Future.wait([
      _playSound('sounds/wrong.mp3'),
      _vibrate(duration: 150, amplitude: 255),
    ]);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
