import 'dart:convert';
import 'dart:io';
import 'package:YogiTech/services/notifi_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:YogiTech/src/widgets/checkbox.dart';
import 'package:YogiTech/src/widgets/switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({
    super.key,
  });

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final List<Map<String, dynamic>> _selectedTimes = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final reminderData = prefs.getString('reminders');
    print('Dữ liệu thông báo: $reminderData');
    if (reminderData != null) {
      final List<dynamic> parsedData = jsonDecode(reminderData);
      setState(() {
        _selectedTimes.clear();
        _selectedTimes.addAll(parsedData.map((item) {
          return {
            'id': item['id'],
            'time': TimeOfDay(
              hour: int.parse(item['time'].split(':')[0]),
              minute: int.parse(item['time'].split(':')[1]),
            ),
            'days': Set<int>.from(item['days']),
            'isEnabled': item['isEnabled'] ?? true, // Default to true if null
          };
        }).toList());
      });
    }
  }

  Future<void> _saveReminders() async {
    final trans = AppLocalizations.of(context)!;
    final prefs = await SharedPreferences.getInstance();
    final reminderData = _selectedTimes.map((item) {
      return {
        'id': item['id'],
        'time': '${item['time'].hour}:${item['time'].minute}',
        'days': item['days'].toList(),
        'isEnabled': item['isEnabled'],
      };
    }).toList();
    await prefs.setString('reminders', jsonEncode(reminderData));

    for (var item in _selectedTimes) {
      if (item['isEnabled']) {
        for (var day in item['days']) {
          await LocalNotification.showWeeklyAtDayAndTime(
            id: item['id'],
            title: trans.yourReminder,
            body: trans.yourReminderDetail,
            time: item['time'],
            day: day,
            payload: 'Reminder payload',
          );
        }
      } else {
        await LocalNotification.cancel(item['id']);
      }
    }
  }

  int _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  Future<void> _showSetupReminderPage(BuildContext context,
      {bool isNew = false, int? index}) async {
    final trans = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      backgroundColor: theme.colorScheme.onSecondary,
      elevation: appElevation,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final ScrollController scrollController = ScrollController();

        return _SetupReminderWidget(
          scrollController: scrollController,
          initialTime: isNew ? TimeOfDay.now() : _selectedTimes[index!]['time'],
          initialDays: isNew ? {} : _selectedTimes[index!]['days'],
          showDeleteButton: !isNew,
        );
      },
    );

    if (result != null) {
      if (result.containsKey('delete')) {
        if (index != null) {
          // Xóa nhắc nhở
          await LocalNotification.cancel(_selectedTimes[index]['id']);
          setState(() {
            _selectedTimes.removeAt(index);
          });
          await _saveReminders();
        }
      } else if (result.containsKey('time') && result.containsKey('days')) {
        final timeOfDay = result['time'] as TimeOfDay;
        final days = result['days'] as Set<int>;

        // Tạo ID duy nhất
        int id = isNew ? _generateUniqueId() : _selectedTimes[index!]['id'];

        // Kiểm tra xem có ngày nào được chọn hay không
        if (days.isNotEmpty) {
          if (isNew) {
            setState(() {
              _selectedTimes.add({
                'id': id,
                'time': timeOfDay,
                'days': days,
                'isEnabled': true, // Set isEnabled to true by default
              });
            });
          } else {
            setState(() {
              _selectedTimes[index!] = {
                'id': id,
                'time': timeOfDay,
                'days': days,
                'isEnabled': _selectedTimes[index!]['isEnabled'],
              };
            });
          }

          await _saveReminders();
        } else {
          // Hiển thị thông báo lỗi nếu không có ngày nào được chọn
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(trans.noDays)),
          );
        }
      }
    }
  }

  String _getDayDescription(Set<int> days, AppLocalizations trans) {
    if (days.isEmpty) {
      return trans.noDays;
    }
    if (days.length == 7) return trans.everyday;

    if (days.containsAll([2, 3, 4, 5, 6])) {
      if (days.length == 5) return trans.dayInWeek;
    }

    if (days.containsAll([6, 7])) {
      if (days.length == 2) return trans.dayWeeken;
    }

    List<int> sortedDays = days.toList()..sort();

    // Sử dụng DateFormat để định dạng tên thứ theo locale
    final dateFormat = DateFormat.E(Localizations.localeOf(context).toString());
    List<String> dayNames = sortedDays.map((day) {
      // Chuyển đổi số thứ tự thành DateTime để định dạng
      return dateFormat.format(DateTime(2024, 1, day));
    }).toList();

    return dayNames.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.reminder,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              _selectedTimes.isNotEmpty
                  ? Column(
                      children: _selectedTimes
                          .asMap()
                          .entries
                          .map((entry) => GestureDetector(
                                onTap: () {
                                  _showSetupReminderPage(context,
                                      index: entry.key);
                                },
                                child: CustomSwitch(
                                  title:
                                      '${entry.value['time'].format(context)}',
                                  subtitle: _getDayDescription(
                                      entry.value['days'], trans),
                                  value: entry.value['isEnabled'],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTimes[entry.key]['isEnabled'] =
                                          value;
                                    });
                                    _saveReminders();
                                  },
                                ),
                              ))
                          .toList(),
                    )
                  : Center(
                      child: Text(
                        trans.noReminder,
                        style: bd_text.copyWith(color: text),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
        ),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            _showSetupReminderPage(context, isNew: true);
          },
          child: const Icon(
            Icons.add,
            color: active,
            size: 24,
          ),
        ),
      ),
      onPressed: () {},
    );
  }
}

class _SetupReminderWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final TimeOfDay initialTime;
  final Set<int> initialDays;
  final bool showDeleteButton;

  const _SetupReminderWidget({
    this.scrollController,
    required this.initialTime,
    required this.initialDays,
    required this.showDeleteButton,
  });

  @override
  __SetupReminderWidgetState createState() => __SetupReminderWidgetState();
}

class __SetupReminderWidgetState extends State<_SetupReminderWidget> {
  late TimeOfDay _selectedTime;
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _selectedDays = widget.initialDays;
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  trans.cancel,
                  style: bd_text.copyWith(color: text),
                ),
              ),
              Text(
                trans.setReminder,
                style: h3.copyWith(color: theme.colorScheme.onBackground),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, {
                  'time': _selectedTime,
                  'days': _selectedDays,
                  'isEnabled': true
                }),
                child: Text(
                  trans.save,
                  style: h3.copyWith(color: primary),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 200,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              initialTimerDuration: Duration(
                hours: _selectedTime.hour,
                minutes: _selectedTime.minute,
              ),
              onTimerDurationChanged: (Duration newDuration) {
                setState(() {
                  _selectedTime = TimeOfDay(
                    hour: newDuration.inHours,
                    minute: newDuration.inMinutes.remainder(60),
                  );
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            trans.loopInWeek,
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: stroke),
            ),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListTileTheme(
                      dense: true,
                      child: Column(
                        children: List<Widget>.generate(7, (index) {
                          final dayIndex = index + 1;
                          final dateFormat = DateFormat.EEEE(
                              Localizations.localeOf(context).toString());
                          final dayName =
                              dateFormat.format(DateTime(2024, 1, index + 1));

                          return CheckBoxListTile(
                            title: dayName.toString(),
                            customTextStyle: bd_text.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                            state: _selectedDays.contains(dayIndex)
                                ? CheckState.Checked
                                : CheckState.Unchecked,
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  _selectedDays.add(dayIndex);
                                } else {
                                  _selectedDays.remove(dayIndex);
                                }
                              });
                            },
                          );
                        }),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (widget.showDeleteButton)
            Center(
              child: CustomButton(
                title: trans.deleteReminder,
                style: ButtonStyleType.Tertiary,
                state: ButtonState.Enabled,
                onPressed: () {
                  Navigator.pop(context, {'delete': true});
                },
              ),
            ),
          SizedBox(height: 26),
        ],
      ),
    );
  }
}
