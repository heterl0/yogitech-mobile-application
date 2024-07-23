import 'package:YogiTech/api/exercise/exercise_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

// id thông báo:
// 0: Thông báo kết thúc thiền
// 1: Thông báo nhắc nhở giữ streak
// id+10: Thông báo bạn bè
// ????: Các nhắc nhở do người dùng thiết lập

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  Future<void> init() async {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('yogi', 'YogiTech',
            channelDescription: 'YogiTech notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static showPeriodicNotification({
    required String title,
    required String body,
    required RepeatInterval repeat,
    required String payload,
  }) async {
    final bool hasExercisedToday = await isExerciseToday();

    if (!hasExercisedToday) {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('yogi2', 'YogiTech',
              channelDescription: 'YogiTech notification',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await _flutterLocalNotificationsPlugin.periodicallyShow(
          1, title, body, repeat, notificationDetails,
          payload: payload);
    }
  }

  static Future showFriendNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('yogi3', 'YogiTech',
            channelDescription: 'YogiTech notification',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, notificationDetails, payload: payload);
  }

  static Day _convertIntToDay(int day) {
    switch (day) {
      case DateTime.monday:
        return Day.monday;
      case DateTime.tuesday:
        return Day.tuesday;
      case DateTime.wednesday:
        return Day.wednesday;
      case DateTime.thursday:
        return Day.thursday;
      case DateTime.friday:
        return Day.friday;
      case DateTime.saturday:
        return Day.saturday;
      case DateTime.sunday:
        return Day.sunday;
      default:
        throw ArgumentError('Invalid day value');
    }
  }

  static Future showWeeklyAtDayAndTime({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required int day,
    required String payload,
  }) async {
    tz.TZDateTime scheduledDate =
        _nextInstanceOfDayAndTime(_convertIntToDay(day), time)
            .subtract(const Duration(days: 1));

    // Sử dụng múi giờ địa phương cho thời gian hiện tại
    final now = tz.TZDateTime.now(tz.local);
    print('Thời gian hệ thống hiện tại: $now');
    // In ra thời gian đã được tính toán
    print('Scheduled notification for: $scheduledDate');
    // print('Lên lịch sau 1 phút: ${now.add(Duration(minutes: 1))}');

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'yogi',
          'YogiTech',
          channelDescription: 'YogiTech notification',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
  }

  static tz.TZDateTime _nextInstanceOfDayAndTime(Day day, TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Tính toán số ngày cần thêm vào để đến ngày đã chọn
    int daysDifference = day.value - now.weekday;
    if (daysDifference < 0 ||
        (daysDifference == 0 && scheduledDate.isBefore(now))) {
      daysDifference +=
          7; // Chuyển sang tuần tiếp theo nếu thời gian đã trôi qua trong ngày
    }

    scheduledDate = scheduledDate.add(Duration(days: daysDifference));

    return scheduledDate;
  }

  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
