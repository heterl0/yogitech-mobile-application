import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'dart:math';

class Meditate extends StatefulWidget {
  @override
  _MeditateState createState() => _MeditateState();
}

class _MeditateState extends State<Meditate> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _selectedDuration = const Duration();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomBar(),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: theme.colorScheme.background),
      child: Stack(
        children: [
          _buildTopRoundedContainer(),
          _buildTitleText(),
          _buildMainContent(),
          _buildElevatedButton(context),
        ],
      ),
    );
  }

  Widget _buildTopRoundedContainer() {
    final theme = Theme.of(context);
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    final theme = Theme.of(context);
    return Positioned(
      left: 0,
      right: 0,
      top: 100,
      child: Text('Meditate',
          textAlign: TextAlign.center,
          style: h2.copyWith(color: theme.colorScheme.onBackground)),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    return Positioned(
      left: 24,
      top: 150,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color.fromARGB(
                255, 13, 33, 44), // Set background color directly
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.ms,
              initialTimerDuration: _selectedDuration,
              onTimerDurationChanged: (Duration newDuration) {
                setState(() {
                  _selectedDuration = Duration(
                    minutes: min(newDuration.inMinutes, 60),
                    seconds: min(newDuration.inSeconds % 60, 60),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sounds',
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 16),
          _buildCheckboxItem(
            title: 'Sound of rain',
            subtitle: 'Deep sound on rainy days',
            value: _isChecked1,
            onChanged: (value) {
              setState(() {
                _isChecked1 = value!;
                if (value) _isChecked2 = false;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildCheckboxItem(
            title: 'The sound of the stream flowing',
            subtitle: 'Immersing yourself in the refreshing nature',
            value: _isChecked2,
            onChanged: (value) {
              setState(() {
                _isChecked2 = value!;
                if (value) _isChecked1 = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    final theme = Theme.of(context);
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.transparent,
            checkColor: Colors.white,
            side: MaterialStateBorderSide.resolveWith(
              (states) => const BorderSide(
                color: Colors.white, // Outline color
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                Text(subtitle, style: min_cap.copyWith(color: text)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      right: 27,
      bottom: 20,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          shape: MaterialStateProperty.all(const CircleBorder()),
        ),
        onPressed: () {
          if (_isChecked1) {
            _audioPlayer.play(AssetSource('assets/audios/rain.mp3'));
          } else if (_isChecked2) {
            _audioPlayer.play(AssetSource('assets/audios/tieng_suoi.mp3'));
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  performMeditate(selectedDuration: _selectedDuration),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient, // Áp dụng gradient từ app_colors.dart
          ),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/icons/play_arrow.png',
              width: 24,
              height: 24,
              color: active,
            ),
          ),
        ),
      ),
    );
  }
}
