import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

class LocalNotification {
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
    print('Có kiểm tra giấy phép');
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

  List<tz.TZDateTime> _nextInstancesOfTime(TimeOfDay time, Set<int> days) {
    final now = tz.TZDateTime.now(tz.local);
    List<tz.TZDateTime> scheduledDates = [];

    // Tạo lịch trình cho từng ngày trong tuần được chọn
    for (var day in days) {
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // Tìm ngày tiếp theo trong tuần theo ngày đã chọn
      while (scheduledDate.weekday != day) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // Nếu thời gian đã qua, chuyển sang tuần tiếp theo
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }

      scheduledDates.add(scheduledDate);
    }

    return scheduledDates;
  }

  Future<void> showScheduleNotification({
    required int id,
    required String title,
    required String body,
    required Set<int> days,
    required TimeOfDay time,
    required String payload,
  }) async {
    // Lấy ngày hiện tại và giờ từ thời gian cục bộ
    final now = DateTime.now();

    // Tính toán ngày và giờ chính xác từ `days` và `time`
    DateTime scheduledDateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // Tạo TZDateTime từ scheduledDateTime và local time zone
    final scheduledTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

    tz.initializeTimeZones();
    print('Đã nhận gửi thông báo vào lúc $scheduledTime ');

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id * 10 + 1,
        title,
        body,
        scheduledTime,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    // final scheduledDates = _nextInstancesOfTime(time, days);

    // print('ID: $id, Scheduled Times: $scheduledDates'); // In ra để kiểm tra

    // for (var i = 0; i < scheduledDates.length; i++) {
    //   var scheduledDate = scheduledDates[i];

    //   await _flutterLocalNotificationsPlugin.zonedSchedule(
    //     id * 10 + i, // ID duy nhất
    //     title,
    //     body,
    //     scheduledDate,
    //     const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         'yogi3', // ID kênh thông báo
    //         'YogiTech', // Tên kênh thông báo
    //         channelDescription: 'YogiTech notification',
    //         importance: Importance.max,
    //         priority: Priority.high,
    //         ticker: 'ticker',
    //       ),
    //     ),
    //     payload: payload,
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     matchDateTimeComponents:
    //         DateTimeComponents.dayOfWeekAndTime, // Lặp lại hàng tuần
    //   );
    // }
  }

  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
