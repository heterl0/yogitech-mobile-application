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
  const Meditate({super.key});

  @override
  _MeditateState createState() => _MeditateState();
}

final List<Map<String, dynamic>> theTracks = [
  {'asset': 'assets/audios/rain.mp3'},
  {'asset': 'assets/audios/tieng_suoi.mp3'},
];

class _MeditateState extends State<Meditate> {
  int? _selectedTrackIndex; // Index of the currently selected track

  Duration _selectedDuration = const Duration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: false,
        titleWidget: StreakValue('0'),
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
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> tracks = [
      {
        'title': trans.soundRain,
        'subtitle': trans.soundRainDescription,
      },
      {
        'title': trans.soundStream,
        'subtitle': trans.soundStreamDescription,
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
          ListView.builder(
            key: UniqueKey(),
            shrinkWrap: true,
            itemCount: _tracks.length,
            itemBuilder: (context, index) {
              return CheckBoxListTile(
                title: _tracks[index]['title'],
                subtitle: _tracks[index]['subtitle'],
                state: _selectedTrackIndex == index
                    ? CheckState.Checked
                    : CheckState.Unchecked,
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedTrackIndex = index;
                    } else {
                      _selectedTrackIndex = null;
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
        shape: WidgetStateProperty.all(const CircleBorder()),
      ),
      onPressed: () {
        _selectedTrackIndex != null
            ? pushWithoutNavBar(
                context,
                MaterialPageRoute(
                  builder: (context) => PerformMeditate(
                    selectedDuration: _selectedDuration,
                    audioPath: theTracks[_selectedTrackIndex!]['asset'],
                  ),
                ),
              )
            : pushWithoutNavBar(
                context,
                MaterialPageRoute(
                  builder: (context) => PerformMeditate(
                    selectedDuration: _selectedDuration,
                    audioPath: '',
                  ),
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

class StreakValue extends StatelessWidget {
  final String streakValue;

  const StreakValue(this.streakValue, {super.key});

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            trans.meditationStreak,
            style: min_cap.copyWith(
              color: text,
            ),
          ),
          SizedBox(
            height: 32,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return gradient.createShader(bounds);
              },
              child: Text(
                streakValue,
                style: h2.copyWith(color: active, height: 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}
