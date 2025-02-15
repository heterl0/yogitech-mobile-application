import 'dart:async';
import 'package:YogiTech/notifi_services/notifi_service.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';

class PerformMeditate extends StatefulWidget {
  final Duration duration;
  final String track;
  final VoidCallback? updateStreak;

  const PerformMeditate({
    Key? key,
    this.duration = const Duration(seconds: 5),
    this.track = '',
    this.updateStreak,
  }) : super(key: key);

  @override
  _PerformMeditateState createState() => _PerformMeditateState();
}

class _PerformMeditateState extends State<PerformMeditate>
    with TickerProviderStateMixin {
  late Duration _remainingTime;
  Timer? _timer;
  bool _isPlaying = false;
  late AudioPlayer _audioPlayer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    _remainingTime = widget.duration;
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_remainingTime.inSeconds > 0) {
      if (widget.track != '') {
        _playAudio();
      }
      _animationController.forward();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime -= const Duration(seconds: 1);
          } else {
            timer.cancel();
            print('Đã dừng');
            LocalNotificationService.showSimpleNotification(
                title: AppLocalizations.of(context)!.notiMeditationTitle,
                body: AppLocalizations.of(context)!.notiMeditationBody,
                payload: 'payload');
            _isPlaying = false;
            _stopAudio();
            widget.updateStreak?.call();
            _animationController.reset();
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
    _animationController.stop();
    setState(() {
      _isPlaying = false;
    });

    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause();
    } else if (_audioPlayer.state == PlayerState.paused) {
      _audioPlayer.resume();
    }
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(widget.track));
    } catch (e) {
      print("Error playing audio: $e");
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: trans.meditate,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(),
            Stack(
              // Sử dụng Stack để chồng các widget lên nhau
              alignment:
                  Alignment.center, // Căn giữa các widget con trong Stack
              children: [
                SizedBox(
                  // Thêm SizedBox để điều chỉnh kích thước
                  height: 240, // Chiều cao vòng tròn
                  width: 240, // Chiều rộng vòng tròn
                  child: AnimatedBuilder(
                    // CircularProgressIndicator nằm dưới
                    animation: _animationController,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        strokeCap: StrokeCap.round,
                        value: _animation.value,
                        strokeWidth: 16,
                        backgroundColor: theme.colorScheme.onSecondary,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(primary),
                      );
                    },
                  ),
                ),
                Text(
                  // Text nằm trên
                  _formatDuration(_remainingTime),
                  style: h1.copyWith(color: text),
                ),
              ],
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: 240,
              child: Column(
                children: [
                  CustomButton(
                    title: _isPlaying ? trans.pause : trans.start,
                    style: !_isPlaying
                        ? ButtonStyleType.Primary
                        : ButtonStyleType.Tertiary,
                    onPressed: _isPlaying ? _pauseTimer : _startTimer,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    title: trans.reset,
                    style: ButtonStyleType.Tertiary,
                    onPressed: () {
                      setState(() {
                        _remainingTime = widget.duration;
                        _isPlaying = false;
                        _timer?.cancel();
                        _stopAudio();
                        _animationController.reset();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
