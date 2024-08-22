import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/pages/perform_meditate.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/src/widgets/checkbox.dart';

class Meditate extends StatefulWidget {
  const Meditate({super.key});

  @override
  _MeditateState createState() => _MeditateState();
}

final List<Map<String, dynamic>> theTracks = [
  {'asset': 'audios/rain.mp3'},
  {'asset': 'audios/wave.mp3'},
  {'asset': 'audios/morning.mp3'}
];

class _MeditateState extends State<Meditate> {
  int? _selectedTrackIndex;
  int currentStreak = 0;
  Duration _selectedDuration = const Duration(minutes: 1);
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await _checkStreakData();
    _loadStreakData();
  }

  void _loadStreakData() {
    setState(() {
      currentStreak = prefs?.getInt('currentStreak') ?? 0;
    });
  }

  Future<void> _updateStreakData() async {
    DateTime today = DateTime.now();
    DateTime? lastMeditationDate =
        DateTime.tryParse(prefs?.getString('lastMeditationDate') ?? '');

    if (lastMeditationDate != null) {
      DateTime normalizedToday = DateTime(today.year, today.month, today.day);
      DateTime normalizedLastDate = DateTime(lastMeditationDate.year,
          lastMeditationDate.month, lastMeditationDate.day);
      int daysDifference =
          normalizedToday.difference(normalizedLastDate).inDays;
      if (daysDifference != 0) {
        currentStreak++;
      }
    } else {
      currentStreak = 1;
    }

    await prefs?.setInt('currentStreak', currentStreak);
    await prefs?.setString('lastMeditationDate', today.toIso8601String());
    _loadStreakData();
  }

  Future<void> _checkStreakData() async {
    DateTime today = DateTime.now();
    DateTime? lastMeditationDate =
        DateTime.tryParse(prefs?.getString('lastMeditationDate') ?? '');
    if (lastMeditationDate != null) {
      final int daysDifference = today.difference(lastMeditationDate).inDays;
      if (daysDifference >= 2) {
        await prefs?.setInt('currentStreak', currentStreak);
      }
    }
  }

  Future<void> _resetStreakData() async {
    await prefs?.remove('currentStreak');
    await prefs?.remove('lastMeditationDate');
    setState(() {
      currentStreak = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: false,
        title: trans.meditate,
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
      child: SingleChildScrollView(
        child: _buildMainContent(),
      ),
    );
  }

  Widget _buildMainContent() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> _tracks = [
      {
        'title': trans.soundRain,
        'subtitle': trans.soundRainDescription,
        'asset': 'audios/rain.mp3'
      },
      {
        'title': trans.soundWave,
        'subtitle': trans.soundWaveDescription,
        'asset': 'audios/wave.mp3'
      },
      {
        'title': trans.soundMorning,
        'subtitle': trans.soundMorningDescription,
        'asset': 'audios/morning.mp3'
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStreakInfo(context),
          const SizedBox(height: 16),
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
          ListView(
            shrinkWrap: true,
            children: [
              for (var index = 0; index < _tracks.length; index++)
                CheckBoxListTile(
                  title: _tracks[index]['title'],
                  subtitle: _tracks[index]['subtitle'],
                  state: _selectedTrackIndex == index
                      ? CheckState.Checked
                      : CheckState.Unchecked,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _selectedTrackIndex = index;
                      } else {
                        _selectedTrackIndex = null;
                      }
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: _buildStreakImage(),
        ),
        Expanded(flex: 2, child: _buildStreakText(context)),
      ],
    );
  }

  Widget _buildStreakImage() {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Lotus.png'),
        ),
      ),
    );
  }

  Widget _buildStreakText(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          trans.meditationStreak,
          textAlign: TextAlign.center,
          style: bd_text.copyWith(color: text),
        ),
        ShaderMask(
          shaderCallback: (bounds) {
            return gradient.createShader(bounds);
          },
          child: Text(
            currentStreak.toString(),
            style: const TextStyle(
              color: active,
              fontSize: 60,
              fontFamily: 'ReadexPro',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ],
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
      onPressed: () async {
        pushWithoutNavBar(
          context,
          MaterialPageRoute(
            builder: (context) => PerformMeditate(
                duration: _selectedDuration,
                track: _selectedTrackIndex != null
                    ? theTracks[_selectedTrackIndex!]['asset']
                    : '',
                updateStreak: _updateStreakData),
          ),
        );
      },
      child: Ink(
        decoration: const BoxDecoration(
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
