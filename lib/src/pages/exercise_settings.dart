import 'package:YogiTech/src/widgets/input_button.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/widgets/switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseSettingsPage extends StatefulWidget {
  const ExerciseSettingsPage({
    super.key,
  });

  @override
  _ExerciseSettingsPageState createState() => _ExerciseSettingsPageState();
}

class _ExerciseSettingsPageState extends State<ExerciseSettingsPage> {
  late bool _hideTutorial = false;
  late bool _allowSkip = false;
  late int _delayValue = 10;
  int currentStreak = 0;
  late Future<void> _loadPreferencesFuture;

  @override
  void initState() {
    super.initState();
    _loadPreferencesFuture = _loadSwitchStates(); // Load initial switch states
  }

  Future<void> _loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hideTutorial = prefs.getBool('hideTutorial') ?? false;
      _allowSkip = prefs.getBool('allowSkip') ?? false;
      _delayValue = prefs.getInt('delayValue') ?? 10;
    });
  }

  Future<void> _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveDelayState(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.exerciseSetting,
        style: widthStyle.Large,
      ),
      body: FutureBuilder(
        future: _loadPreferencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    CustomSwitch(
                      title: trans.hideVideoTutorial,
                      value: _hideTutorial,
                      onChanged: (newValue) async {
                        setState(() {
                          _hideTutorial = newValue;
                        });
                        await _saveSwitchState('hideTutorial', newValue);
                        // _handleStreakSaverNotifications(_hideTutorial);
                      },
                    ),
                    CustomSwitch(
                      title: trans.allowSkipExercise,
                      value: _allowSkip,
                      onChanged: (newValue) async {
                        setState(() {
                          _allowSkip = newValue;
                        });
                        await _saveSwitchState('allowSkip', newValue);
                        // _handleNewActivitiesNotifications(_allowSkip);
                      },
                    ),
                    CustomInputButton(
                      title: trans.timeToRest,
                      value: _delayValue,
                      onChanged: (newValue) async {
                        setState(() {
                          _delayValue = newValue;
                        });
                        await _saveDelayState('delayValue', newValue);
                        // _handleNewActivitiesNotifications(_allowSkip);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // void _handleNewActivitiesNotifications(bool isFriendsOn) {
  //   final now = DateTime.now();

  //   if (isFriendsOn) {
  //     print('Bật thông báo các hoạt động');
  //     if (_notifications != null) {
  //       for (var notification in _notifications!) {
  //         final notificationTime = DateTime.parse(notification.time);
  //         if (notificationTime.isAfter(now)) {
  //           print('Thông báo: ${notification}');
  //           LocalNotificationService.showActivitiesNotification(
  //             id: notification.id + 10,
  //             title: notification.title,
  //             body: notification.body,
  //             scheduledTime: notificationTime,
  //             payload: 'friend_notification_${notification.id}',
  //           );
  //         }
  //       }
  //     }
  //   } else {
  //     print('Hủy thông báo của bạn bè');
  //     if (_notifications != null) {
  //       for (var notification in _notifications!) {
  //         LocalNotificationService.cancel(notification.id);
  //       }
  //     }
  //   }
  // }

  // void _handleStreakSaverNotifications(bool isStreakSaverOn) {
  //   if (isStreakSaverOn) {
  //     print('Bật bảo vệ chuỗi');
  //     LocalNotificationService.showPeriodicNotification(
  //       title: AppLocalizations.of(context)!.streakSaver,
  //       body: AppLocalizations.of(context)!.yourReminderDetail,
  //       repeat: RepeatInterval.daily,
  //       payload: 'yoga_reminder',
  //     );
  //   } else {
  //     print('Hủy bảo vệ chuỗi');
  //     LocalNotificationService.cancel(1);
  //   }
  // }
}
