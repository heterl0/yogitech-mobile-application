import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart'; // Đoạn này bạn cần thay đổi tên package theo project của bạn
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';

class PerformMeditate extends StatefulWidget {
  final Duration selectedDuration;
  final String audioPath;

  const PerformMeditate({
    Key? key,
    this.selectedDuration = const Duration(seconds: 5),
    this.audioPath = '',
  }) : super(key: key);

  @override
  _PerformMeditateState createState() => _PerformMeditateState();
}

class _PerformMeditateState extends State<PerformMeditate> {
  late Duration _remainingTime;
  Timer? _timer;
  bool _isPlaying = false;
  late AudioPlayer
      _audioPlayer; // Đã thêm biến _audioPlayer để quản lý player audio

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.selectedDuration;
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_remainingTime.inSeconds > 0) {
      _playAudio();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime -= Duration(seconds: 1);
          } else {
            timer.cancel();
            _isPlaying = false;
            _stopAudio();
          }
        });
      });
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause(); // Tạm dừng audio nếu đang phát
    } else if (_audioPlayer.state == PlayerState.paused) {
      _audioPlayer.resume(); // Tiếp tục audio nếu đang tạm dừng
    }
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(widget.audioPath));
    } catch (e) {
      print("Error playing audio: $e"); // In ra thông tin lỗi cụ thể
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: trans.meditate,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(_remainingTime),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isPlaying ? _pauseTimer : _startTimer,
                  child: Text(_isPlaying ? trans.pause : trans.start),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _remainingTime = widget.selectedDuration;
                      _isPlaying = false;
                      _timer?.cancel();
                      _stopAudio(); // Dừng phát audio khi reset
                    });
                  },
                  child: Text(trans.reset),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
