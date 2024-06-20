import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yogi_application/src/widgets/checkbox.dart';

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
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: false,
        title: trans.meditate,
        style: widthStyle.Medium,
      ),
      body: _buildBody(),
      floatingActionButton: _buildElevatedButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Positioned(
      left: 24,
      top: 24,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: theme.colorScheme.onSecondary,
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
            trans.sounds,
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 16),
          // CheckBoxListTile(
          //   title: trans.soundRain,
          //   subtitle: trans.soundRain == 'Sound of rain'
          //       ? 'Deep sound on rainy days.'
          //       : 'Âm thanh sâu lắng trong những ngày mưa.',
          //   state: _isChecked1 ? CheckState.Checked : CheckState.Unchecked,
          //   onChanged: (value) {
          //     setState(() {
          //       _isChecked1 = value!;
          //       if (value) _isChecked2 = false;
          //     });
          //   },
          // ),
          // const SizedBox(height: 16),
          CheckBoxListTile(
            title: trans.soundStream,
            subtitle: trans.soundStream == 'The sound of the stream flowing'
                ? 'Immersing yourself in the refreshing nature.'
                : "Âm thanh suối chảy hòa mình vào thiên nhiên trong lành.",
            state: _isChecked2 ? CheckState.Checked : CheckState.Unchecked,
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

  Widget _buildElevatedButton(BuildContext context) {
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
            gradient: gradient,
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
