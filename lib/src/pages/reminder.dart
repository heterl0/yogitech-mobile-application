import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/switch.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Alarm> alarms = [];
  int alarmIdCounter = 0;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final locationName = 'Asia/Ho_Chi_Minh';
    tz.setLocalLocation(tz.getLocation(locationName));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _loadAlarms();
  }

  // Function to load alarms from SharedPreferences
  Future<void> _loadAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final alarmData = prefs.getStringList('alarms');
    if (alarmData != null) {
      setState(() {
        alarms = alarmData
            .map((alarmJson) => Alarm.fromJson(jsonDecode(alarmJson)))
            .toList();
        alarmIdCounter = alarms.isNotEmpty
            ? alarms.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1
            : 0;
      });
    }
  }

  // Function to save alarms to SharedPreferences
  Future<void> _saveAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'alarms', alarms.map((alarm) => jsonEncode(alarm.toJson())).toList());
  }

  Future<void> _scheduleAlarm(Alarm alarm) async {
    for (var day in alarm.repeatDays) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          alarm.id,
          alarm.title,
          'Đến giờ rồi!',
          _nextInstanceOfTime(alarm.time, day),
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name'),
          ),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime time, int day) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 7));
    }

    return scheduledDate;
  }

  void _showRepeatDaysDialog(BuildContext context, TimeOfDay time) {
    List<int> selectedDays = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Chọn ngày lặp lại'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CheckboxListTile(
                    title: Text('Thứ 2'),
                    value: selectedDays.contains(DateTime.monday),
                    onChanged: (bool? value) {
                      setState(() {
                        value!
                            ? selectedDays.add(DateTime.monday)
                            : selectedDays.remove(DateTime.monday);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Thứ 3'),
                    value: selectedDays.contains(DateTime.tuesday),
                    onChanged: (bool? value) {
                      setState(() {
                        value!
                            ? selectedDays.add(DateTime.tuesday)
                            : selectedDays.remove(DateTime.tuesday);
                      });
                    },
                  ),
                  // Add CheckboxListTile for other days (Wednesday, Thursday, etc.)
                  CheckboxListTile(
                    title: Text('Thứ 4'),
                    value: selectedDays.contains(DateTime.wednesday),
                    onChanged: (bool? value) {
                      setState(() {
                        value!
                            ? selectedDays.add(DateTime.wednesday)
                            : selectedDays.remove(DateTime.wednesday);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Thứ 5'),
                    value: selectedDays.contains(DateTime.thursday),
                    onChanged: (bool? value) {
                      setState(() {
                        value!
                            ? selectedDays.add(DateTime.thursday)
                            : selectedDays.remove(DateTime.thursday);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Thứ 6'),
                    value: selectedDays.contains(DateTime.friday),
                    onChanged: (bool? value) {
                      setState(() {
                        value!
                            ? selectedDays.add(DateTime.friday)
                            : selectedDays.remove(DateTime.friday);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Thứ 7'),
                    value: selectedDays.contains(DateTime.saturday),
                    onChanged: (bool? value) {
                      setState(() {
                        value!
                            ? selectedDays.add(DateTime.saturday)
                            : selectedDays.remove(DateTime.saturday);
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Chủ nhật'),
                    value: selectedDays.contains(DateTime.sunday),
                    onChanged: (bool? value) {
                      setState(() {
                        value!
                            ? selectedDays.add(DateTime.sunday)
                            : selectedDays.remove(DateTime.sunday);
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Hủy'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Đặt báo thức'),
                  onPressed: () {
                    final now = DateTime.now();
                    final scheduledDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      time.hour,
                      time.minute,
                    );

                    final newAlarm = Alarm(
                      id: alarmIdCounter++,
                      title: 'Báo thức',
                      time: scheduledDateTime,
                      repeatDays: selectedDays,
                    );

                    // Update the state and save alarms BEFORE popping
                    setState(() {
                      alarms.add(newAlarm);
                    });
                    _scheduleAlarm(newAlarm);
                    _saveAlarms();

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay _time = TimeOfDay.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt báo thức'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _time,
                );
                if (picked != null && picked != _time) {
                  setState(() {
                    _time = picked;
                  });
                  _showRepeatDaysDialog(context, picked);
                }
              },
              child: Text('Chọn giờ báo thức'),
            ),
            Text(
              'Báo thức đặt lúc: ${_time.format(context)}',
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return ListTile(
                    title: Text(
                        '${alarm.title} - ${alarm.time.hour}:${alarm.time.minute}'),
                    subtitle: Text(
                        'Lặp lại vào các ngày: ${alarm.repeatDays.join(', ')}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Alarm {
  final int id;
  final String title;
  final DateTime time;
  final List<int> repeatDays;

  Alarm(
      {required this.id,
      required this.title,
      required this.time,
      required this.repeatDays});

  // Convert Alarm to JSON-encodable map
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time': time.toIso8601String(),
        'repeatDays': repeatDays,
      };

  // Create Alarm from JSON map
  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        id: json['id'],
        title: json['title'],
        time: DateTime.parse(json['time']),
        repeatDays: List<int>.from(json['repeatDays']),
      );
}
