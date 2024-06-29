import 'package:YogiTech/services/notifi_service.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/widgets/switch.dart'; // Assuming this is CustomSwitch
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  final bool streakSaverOn;
  final bool friendAactivitiesOn;
  final bool newEventOn;
  // final ValueChanged<bool> areRemindersEnabled;

  const NotificationsPage({
    super.key,
    this.streakSaverOn = true,
    this.friendAactivitiesOn = true,
    this.newEventOn = true,
    // this.areRemindersEnabled,
  });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late bool _streakSaverOn;
  late bool _friendActivitiesOn;
  late bool _newEventOn;
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadSwitchStates(); // Load initial switch states
  }

  Future<void> _loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentStreak = prefs.getInt('currentStreak') ?? 0;
      _streakSaverOn = prefs.getBool('streakSaverOn') ?? widget.streakSaverOn;
      _friendActivitiesOn =
          prefs.getBool('friendActivitiesOn') ?? widget.friendAactivitiesOn;
      _newEventOn = prefs.getBool('newEventOn') ?? widget.newEventOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.notifications,
        style: widthStyle.Large,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              CustomSwitch(
                title: trans.streakSaver,
                value: _streakSaverOn,
                onChanged: (newValue) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('streakSaverOn', newValue);
                  setState(() {
                    _streakSaverOn = newValue;
                  });
                  _handleStreakSaverNotifications(_streakSaverOn);
                },
              ),
              CustomSwitch(
                title: trans.friendsActivities,
                value: _friendActivitiesOn,
                onChanged: (newValue) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('friendActivitiesOn', newValue);
                  setState(() {
                    _friendActivitiesOn = newValue;
                  });
                },
              ),
              CustomSwitch(
                title: trans.newEvent,
                value: _newEventOn,
                onChanged: (newValue) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('newEventOn', newValue);
                  setState(() {
                    _newEventOn = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _handleStreakSaverNotifications(bool isStreakSaverOn) {
    if (isStreakSaverOn && currentStreak > 0) {
      // Hiển thị thông báo định kỳ
      LocalNotification.showPeriodicNotification(
        title: 'Giờ tập Yoga!',
        body: 'Đã đến giờ tập luyện của bạn.',
        repeat: RepeatInterval.daily,
        payload: 'yoga_reminder',
      );
    } else {
      print('Hủy bảo vệ chuỗi');
      // Hủy thông báo định kỳ (nếu đang có)
      LocalNotification.cancel(1);
    }
  }
}
