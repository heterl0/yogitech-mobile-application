import 'dart:io';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/widgets.dart'; // Để sử dụng AnimatedList
import 'dart:convert';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late FlutterLocalNotificationsPlugin _notification;
  List<Reminder> reminders = [];
  int reminderIdCounter = 0;

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _notification
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isGranted) {
        print('Exact alarm permission granted.');
      } else {
        if (await Permission.scheduleExactAlarm.request().isGranted) {
          print('Exact alarm permission granted.');
        } else {
          print('Exact alarm permission denied.');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    const locationName = 'Asia/Ho_Chi_Minh';
    tz.setLocalLocation(tz.getLocation(locationName));

    _notification = FlutterLocalNotificationsPlugin();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings());

    _notification.initialize(initializationSettings);
    _requestPermissions(); // Thêm dòng này
    _loadReminders().then((_) {
      for (var reminder in reminders) {
        _scheduleReminder(reminder);
      }
    });
  }

  // Function to load reminders from SharedPreferences
  Future<void> _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final reminderData = prefs.getStringList('reminders');
    if (reminderData != null) {
      setState(() {
        reminders = reminderData
            .map((reminderJson) => Reminder.fromJson(jsonDecode(reminderJson)))
            .toList();
        reminderIdCounter = reminders.isNotEmpty
            ? reminders.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1
            : 0;
      });
    }
  }

  Future<void> _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'reminders',
      reminders.map((reminder) => jsonEncode(reminder.toJson())).toList(),
    );
    setState(() {}); // Trigger UI update after saving
  }

  Future<void> _scheduleReminder(Reminder reminder) async {
    for (var day in reminder.repeatDays) {
      print(
          'Lên lịch nhắc nhở với ID: ${reminder.id}, Thời gian: ${reminder.time}, Ngày lặp lại: $day');
      await _notification.zonedSchedule(
        reminder.id,
        reminder.title,
        'Đến giờ rồi!',
        _nextInstanceOfTime(reminder.time, day),
        const NotificationDetails(
          android: AndroidNotificationDetails('theReminder', 'Reminder',
              importance: Importance.max, priority: Priority.high),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
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

  void _showRepeatDaysDialog(BuildContext context) {
    DateTime selectedDateTime = DateTime.now();
    List<int> selectedDays = [];

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Chọn giờ và ngày lặp lại'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    // Giới hạn chiều cao của CupertinoDatePicker
                    height: 180,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: selectedDateTime,
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() {
                          selectedDateTime = newTime;
                        });
                      },
                      use24hFormat: true, // Hiển thị AM/PM
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                      'Giờ đã chọn: ${TimeOfDay.fromDateTime(selectedDateTime).format(context)}'),
                  SizedBox(height: 16),
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
                  child: Text('Đặt nhắc nhở'),
                  onPressed: () {
                    final newReminder = Reminder(
                      id: reminderIdCounter++,
                      title: 'Nhắc nhở',
                      time: selectedDateTime,
                      repeatDays: selectedDays,
                    );

                    setState(() {
                      reminders.add(newReminder);
                      _scheduleReminder(newReminder);
                    });

                    _saveReminders();

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

  void _showEditReminderDialog(BuildContext context, Reminder reminder) {
    DateTime selectedDateTime = reminder.time;
    List<int> selectedDays = List.from(reminder.repeatDays); // Copy days

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Chỉnh sửa nhắc nhở'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    // Giới hạn chiều cao của CupertinoDatePicker
                    height: 180,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: selectedDateTime,
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() {
                          selectedDateTime = newTime;
                        });
                      },
                      use24hFormat: true, // Hiển thị AM/PM
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                      'Giờ đã chọn: ${TimeOfDay.fromDateTime(selectedDateTime).format(context)}'),
                  SizedBox(height: 16),
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
                  child: Text('Lưu'),
                  onPressed: () {
                    final editedReminder = Reminder(
                      id: reminder.id,
                      title: 'Nhắc nhở',
                      time: selectedDateTime,
                      repeatDays: selectedDays,
                    );

                    setState(() {
                      reminders[reminders.indexWhere(
                          (r) => r.id == reminder.id)] = editedReminder;
                      _notification.cancel(reminder.id);
                      _scheduleReminder(editedReminder);
                    });

                    _saveReminders();

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

  void _removeReminder(Reminder reminder) {
    setState(() {
      reminders.remove(reminder);
      _notification.cancel(reminder.id);
    });

    _saveReminders();
  }

  void _sendTestNotification() async {
    await _notification.show(
      0,
      'Nhắc nhở thử',
      'Đây là thông báo thử',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'testReminder',
          'Test Reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  void _sendTestScheduledNotification() async {
    final now = DateTime.now();
    final testTime = DateTime(now.year, now.month, now.day, now.hour,
        now.minute + 1); // 1 minute later

    print('Scheduling test notification for: $testTime');

    if (Platform.isAndroid) {
      var status = await Permission.scheduleExactAlarm.status;
      if (status.isGranted) {
        await _notification
            .zonedSchedule(
          1,
          'Thông báo thử nghiệm',
          'Đây là thông báo thử nghiệm đã được lên lịch',
          tz.TZDateTime.from(testTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'testReminder',
              'Test Reminder',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        )
            .then((_) {
          print('Notification scheduled successfully');
        }).catchError((error) {
          print('Error scheduling notification: $error');
        });
      } else {
        if (await Permission.scheduleExactAlarm.request().isGranted) {
          print('Exact alarm permission granted.');
          // Retry scheduling the notification after permission is granted
          _sendTestScheduledNotification();
        } else {
          print('Exact alarm permission denied.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhắc nhở định kỳ'),
        backgroundColor: Colors.black,
      ),
      body: reminders.isEmpty
          ? Center(child: Text('Chưa có nhắc nhở nào'))
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ListTile(
                  title: Text(reminder.title),
                  subtitle: Text(
                      'Lặp lại vào các ngày: ${reminder.repeatDays.map((day) => _dayToString(day)).join(', ')} lúc ${TimeOfDay.fromDateTime(reminder.time).format(context)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            _showEditReminderDialog(context, reminder),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeReminder(reminder),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showRepeatDaysDialog(context),
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _sendTestNotification,
            child: Icon(Icons.notifications),
            backgroundColor: Colors.black,
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _sendTestScheduledNotification,
            child: Icon(Icons.alarm),
            backgroundColor: Colors.black,
          ),
        ],
      ),
    );
  }

  String _dayToString(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Thứ 2';
      case DateTime.tuesday:
        return 'Thứ 3';
      case DateTime.wednesday:
        return 'Thứ 4';
      case DateTime.thursday:
        return 'Thứ 5';
      case DateTime.friday:
        return 'Thứ 6';
      case DateTime.saturday:
        return 'Thứ 7';
      case DateTime.sunday:
        return 'Chủ nhật';
      default:
        return '';
    }
  }
}

class Reminder {
  final int id;
  final String title;
  final DateTime time;
  final List<int> repeatDays;

  Reminder({
    required this.id,
    required this.title,
    required this.time,
    required this.repeatDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'repeatDays': repeatDays,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      time: DateTime.parse(json['time']),
      repeatDays: List<int>.from(json['repeatDays']),
    );
  }
}
