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
  {'asset': 'audios/water_cave.mp3'},
];

class _MeditateState extends State<Meditate> {
  int? _selectedTrackIndex;
  int currentStreak = 0;

  Duration _selectedDuration = const Duration();

  @override
  void initState() {
    super.initState();
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentStreak = prefs.getInt('currentStreak') ?? 0;
    });
  }

  Future<void> _updateStreakData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    DateTime? lastMeditationDate =
        DateTime.tryParse(prefs.getString('lastMeditationDate') ?? '');

    int currentStreak = prefs.getInt('currentStreak') ?? 0;
    int longestStreak = prefs.getInt('longestStreak') ?? 0;

    // Check if there is a last meditation date
    if (lastMeditationDate != null) {
      // Normalize dates to compare only year, month, and day
      DateTime normalizedToday = DateTime(today.year, today.month, today.day);
      DateTime normalizedLastDate = DateTime(lastMeditationDate.year,
          lastMeditationDate.month, lastMeditationDate.day);

      int daysDifference =
          normalizedToday.difference(normalizedLastDate).inDays;
      print(
          'daysDifference:$daysDifference   normalizedLastDate:$normalizedLastDate lastMeditationDate:$lastMeditationDate');
      // If the difference is 1 day, increment streak
      if (daysDifference == 1) {
        currentStreak++;
      } else if (daysDifference > 1) {
        // If the difference is more than 1 day, reset streak
        currentStreak = 1;
      }
      // If the difference is 0 days, do nothing (already counted for today)
    } else {
      // If there is no last meditation date, this is the first meditation
      currentStreak = 1;
    }

    // Update longest streak if current streak is greater
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
      await prefs.setInt('longestStreak', longestStreak);
    }

    // Save current streak and last meditation date
    await prefs.setInt('currentStreak', currentStreak);
    await prefs.setString('lastMeditationDate', today.toIso8601String());
    await _loadStreakData();
  }

  Future<void> _resetStreakData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentStreak');
    await prefs.remove('lastMeditationDate');
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
          _buildStreakInfo(context),

          SizedBox(height: 16),
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
                    if (value) {
                      _selectedTrackIndex = index;
                    } else {
                      _selectedTrackIndex = null;
                    }
                  });
                },
              );
            },
          ),
          // ElevatedButton(
          //   onPressed: _resetStreakData,
          //   child: Text('Reset Streak'),
          // ),
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
        Expanded(
          flex: 2,
          child: _buildStreakText(context),
        ),
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
            style: TextStyle(
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
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        shape: MaterialStateProperty.all(const CircleBorder()),
      ),
      onPressed: () async {
        await _updateStreakData();
        pushWithoutNavBar(
          context,
          MaterialPageRoute(
            builder: (context) => PerformMeditate(
              selectedDuration: _selectedDuration,
              audioPath: _selectedTrackIndex != null
                  ? theTracks[_selectedTrackIndex!]['asset']
                  : '',
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
