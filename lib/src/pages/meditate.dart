import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
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
  // Data for track options

  int? _selectedTrackIndex; // Index of the currently selected track

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
      child: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> _tracks = [
      {
        'title': trans.soundRain,
        'subtitle': trans.soundRainDescription,
        'asset': 'assets/audios/rain.mp3'
      },
      {
        'title': trans.soundStream,
        'subtitle': trans.soundStreamDescription,
        'asset': 'assets/audios/tieng_suoi.mp3'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
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
          for (int i = 0; i < _tracks.length; i++)
            CheckBoxListTile(
              title: _tracks[i]['title'],
              subtitle: _tracks[i]['subtitle'],
              state: _selectedTrackIndex == i
                  ? CheckState.Checked
                  : CheckState.Unchecked,
              onChanged: (value) {
                // setState(() {
                //   if (value!) {
                //     _selectedTrackIndex = i;
                //   } else {
                //     _selectedTrackIndex = null;
                //   }
                // });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        shape: MaterialStateProperty.all(const CircleBorder()),
      ),
      onPressed: () {
        if (_selectedTrackIndex == 1) {
          _audioPlayer.play(AssetSource('assets/audios/rain.mp3'));
        } else if (_selectedTrackIndex == 2) {
          _audioPlayer.play(AssetSource('assets/audios/tieng_suoi.mp3'));
        }
        pushWithoutNavBar(
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
    );
  }
}
