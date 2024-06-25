import 'dart:io';
import 'package:YogiTech/services/notifi_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:YogiTech/src/widgets/switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart'; // Để sử dụng AnimatedList

class ReminderPage extends StatefulWidget {
  final bool reminderOn;

  const ReminderPage({
    super.key,
    this.reminderOn = true,
  });

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  bool _isReminderEnabled = false;
  final List<Map<String, dynamic>> _selectedTimes = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final reminderData = prefs.getString('reminders');
    if (reminderData != null) {
      setState(() {
        _selectedTimes.addAll(List<Map<String, dynamic>>.from(
          (prefs.getStringList('reminders') ?? []).map(
            (item) => Map<String, dynamic>.from(
              item as Map<String, dynamic>,
            ),
          ),
        ));
      });
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final reminderData = _selectedTimes
        .map(
            (item) => item.map((key, value) => MapEntry(key, value.toString())))
        .toList();
    await prefs.setStringList('reminders', reminderData.cast<String>());
  }

  String _getDayDescription(Set<int> days, AppLocalizations trans) {
    String local = trans.locale;
    if (days.isEmpty) {
      return local == "en" ? 'No days selected.' : 'Không có ngày được chọn.';
    }
    if (days.length == 7) return trans.everyday;

    if (days.containsAll([2, 3, 4, 5, 6])) {
      if (days.length == 5) return trans.dayInWeek;
    }

    if (days.containsAll([6, 7])) {
      if (days.length == 2) return trans.dayWeeken;
    }

    List<int> sortedDays = days.toList()..sort();
    List<String> dayNames = sortedDays.map((day) {
      switch (day) {
        case 1:
          return local == "en" ? 'Mon' : 'Thứ 2';
        case 2:
          return local == "en" ? 'Tue' : 'Thứ 3';
        case 3:
          return local == "en" ? 'Wed' : 'Thứ 4';
        case 4:
          return local == "en" ? 'Thu' : 'Thứ 5';
        case 5:
          return local == "en" ? 'Fri' : 'Thứ 6';
        case 6:
          return local == "en" ? 'Sat' : 'Thứ 7';
        case 7:
          return local == "en" ? 'Sun' : 'Chủ nhật';
        default:
          return '';
      }
    }).toList();
    return dayNames.join(', ');
  }

  Future<void> _showSetupReminderPage(BuildContext context,
      {bool isNew = false, int? index}) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final ScrollController scrollController = ScrollController();

        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: _SetupReminderWidget(
              scrollController: scrollController,
              initialTime:
                  isNew ? TimeOfDay.now() : _selectedTimes[index!]['time'],
              initialDays: isNew ? {} : _selectedTimes[index!]['days'],
              showDeleteButton: !isNew,
            ),
          ),
        );
      },
    );

    if (result != null) {
      if (result.containsKey('delete')) {
        if (index != null) {
          setState(() {
            _selectedTimes.removeAt(index);
          });
          _saveReminders();
        }
      } else if (result.containsKey('time') && result.containsKey('days')) {
        final timeOfDay = result['time'] as TimeOfDay;
        final days = result['days'] as Set<int>;
        final notificationPayload =
            'your_payload_here'; // Thay bằng payload thích hợp

        LocalNotification localNotification = LocalNotification();
        localNotification.showScheduleNotification(
          title: 'Your title',
          body: 'Your body',
          time: timeOfDay,
          days: days,
          payload: notificationPayload,
        );

        Navigator.pop(context);
        if (isNew) {
          setState(() {
            _selectedTimes
                .add({'time': result['time'], 'days': result['days']});
          });
        } else {
          setState(() {
            _selectedTimes[index!] = {
              'time': result['time'],
              'days': result['days']
            };
          });
        }
        _saveReminders();
      }
    }
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
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              CustomSwitch(
                title: trans.reminder,
                value: widget.reminderOn,
                onChanged: null,
              ),
              Divider(
                color: stroke,
              ),
              Column(
                children: _selectedTimes
                    .asMap()
                    .entries
                    .map((entry) => GestureDetector(
                          onTap: () {
                            _showSetupReminderPage(context, index: entry.key);
                          },
                          child: CustomSwitch(
                            title: '${entry.value['time'].format(context)}',
                            subtitle:
                                _getDayDescription(entry.value['days'], trans),
                            value: _isReminderEnabled,
                            onChanged: (value) {
                              setState(() {
                                _isReminderEnabled = value;
                              });
                            },
                          ),
                        ))
                    .toList(),
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
          gradient: gradient, // Gradient từ app_colors.dart
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
      onPressed: () {}, // Cái này nhấn không có tác dụng
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
  bool _loopEnabled = false;
  late TimeOfDay _selectedTime;
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _selectedDays = widget.initialDays;
    _loopEnabled = _selectedDays.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    String local = trans.locale;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                trans.cancel,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(trans.setReminder, style: h3.copyWith(color: Colors.white)),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, {'time': _selectedTime, 'days': _selectedDays});
              },
              child: Text(
                trans.save,
                style: h3.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: widget.scrollController,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            ListTile(
              title: Text(trans.reTime),
              trailing: InkWell(
                onTap: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _selectedTime = timeOfDay;
                    });
                  }
                },
                child: Text(
                  _selectedTime.format(context),
                  style: h3,
                ),
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text(trans.loop),
              value: _loopEnabled,
              onChanged: (value) {
                setState(() {
                  _loopEnabled = value;
                  if (!_loopEnabled) {
                    _selectedDays.clear();
                  }
                });
              },
            ),
            if (_loopEnabled)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 10.0,
                  children: List<Widget>.generate(7, (index) {
                    final dayIndex = index + 1;
                    final isSelected = _selectedDays.contains(dayIndex);
                    return ChoiceChip(
                      label: Text(
                        local == "en"
                            ? [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ][index]
                            : [
                                'Thứ 2',
                                'Thứ 3',
                                'Thứ 4',
                                'Thứ 5',
                                'Thứ 6',
                                'Thứ 7',
                                'Chủ nhật'
                              ][index],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(dayIndex);
                          } else {
                            _selectedDays.remove(dayIndex);
                          }
                        });
                      },
                    );
                  }),
                ),
              ),
            if (widget.showDeleteButton)
              Center(
                child: CustomButton(
                  title: trans.deleteReminder,
                  style: ButtonStyleType.Secondary,
                  state: ButtonState.Enabled,
                  onPressed: () {
                    Navigator.pop(context, {'delete': true});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
