import 'dart:async';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late Duration _remainingTime;
  Timer? _timer;
  bool _isPlaying = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.selectedDuration;
    _audioPlayer = AudioPlayer();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification() async {
    print('Thông báo');
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      AppLocalizations.of(context)!.notiMeditationTitle,
      AppLocalizations.of(context)!.notiMeditationBody,
      notificationDetails,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_remainingTime.inSeconds > 0) {
      if (widget.audioPath != '') {
        _playAudio();
      }
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime -= Duration(seconds: 1);
          } else {
            timer.cancel();
            _isPlaying = false;
            _stopAudio();
            _showNotification(); // Show notification when timer completes
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
      _audioPlayer.pause();
    } else if (_audioPlayer.state == PlayerState.paused) {
      _audioPlayer.resume();
    }
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(widget.audioPath));
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

    return Scaffold(
      appBar: CustomAppBar(
        title: trans.meditate,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              children: [],
            ),
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
                  SizedBox(height: 16),
                  CustomButton(
                    title: trans.reset,
                    style: ButtonStyleType.Tertiary,
                    onPressed: () {
                      setState(() {
                        _remainingTime = widget.selectedDuration;
                        _isPlaying = false;
                        _timer?.cancel();
                        _stopAudio();
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
