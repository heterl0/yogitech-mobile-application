import 'package:YogiTech/notifi_services/notifi_service.dart';
import 'package:YogiTech/services/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/custombar/appbar.dart';
import 'package:YogiTech/widgets/switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:YogiTech/models/notification.dart' as n;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
  });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late bool _streakSaverOn = false;
  late bool _friendActivitiesOn = false;
  late List<n.Notification>? _notifications;
  int currentStreak = 0;
  late Future<void> _loadPreferencesFuture;

  @override
  void initState() {
    super.initState();
    fetchNotification();
    _loadPreferencesFuture = _loadSwitchStates(); // Load initial switch states
  }

  Future<void> fetchNotification() async {
    final notifications = await getNotifications();
    setState(() {
      _notifications = notifications.cast<n.Notification>();
    });
  }

  Future<void> _loadSwitchStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentStreak = prefs.getInt('currentStreak') ?? 0;
      _streakSaverOn = prefs.getBool('streakSaverOn') ?? false;
      _friendActivitiesOn = prefs.getBool('friendActivitiesOn') ?? false;
    });
  }

  Future<void> _saveSwitchState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
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
                      title: trans.streakSaver,
                      value: _streakSaverOn,
                      onChanged: (newValue) async {
                        setState(() {
                          _streakSaverOn = newValue;
                        });
                        await _saveSwitchState('streakSaverOn', newValue);
                        _handleStreakSaverNotifications(_streakSaverOn);
                      },
                    ),
                    CustomSwitch(
                      title: trans.newActivities,
                      value: _friendActivitiesOn,
                      onChanged: (newValue) async {
                        setState(() {
                          _friendActivitiesOn = newValue;
                        });
                        await _saveSwitchState('friendActivitiesOn', newValue);
                        _handleNewActivitiesNotifications(_friendActivitiesOn);
                      },
                    ),
                    // CustomSwitch(
                    //   title: trans.newEvent,
                    //   value: _newEventOn,
                    //   onChanged: (newValue) async {
                    //     setState(() {
                    //       _newEventOn = newValue;
                    //     });
                    //     await _saveSwitchState('newEventOn', newValue);
                    //   },
                    // ),
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

  void _handleNewActivitiesNotifications(bool isFriendsOn) async {
    DateTime now = DateTime.now().subtract(Duration(minutes: 15));
    await fetchNotification();
    if (isFriendsOn) {
      print('Bật thông báo các hoạt động');
      if (_notifications != null) {
        for (var notification in _notifications!) {
          final notificationTime = DateTime.parse(notification.time);
          if (notificationTime.isAfter(now)) {
            print('Thông báo: ${notification}');
            LocalNotificationService.showActivitiesNotification(
              id: notification.id + 10,
              title: notification.title,
              body: notification.body,
              scheduledTime: notificationTime,
              payload: 'friend_notification_${notification.id}',
            );
          }
        }
      }
    } else {
      print('Hủy thông báo của bạn bè');
      if (_notifications != null) {
        for (var notification in _notifications!) {
          LocalNotificationService.cancel(notification.id);
        }
      }
      Workmanager().cancelAll();
    }
  }

  void _handleStreakSaverNotifications(bool isStreakSaverOn) {
    if (isStreakSaverOn) {
      print('Bật bảo vệ chuỗi');
      LocalNotificationService.showPeriodicNotification(
        title: AppLocalizations.of(context)!.streakSaver,
        body: AppLocalizations.of(context)!.yourReminderDetail,
        repeat: RepeatInterval.daily,
        payload: 'yoga_reminder',
      );
    } else {
      print('Hủy bảo vệ chuỗi');
      LocalNotificationService.cancel(1);
    }
  }
}
