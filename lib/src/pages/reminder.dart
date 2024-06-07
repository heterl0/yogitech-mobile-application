import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/widgets/switch.dart'; // Assuming this is CustomSwitch
import 'package:yogi_application/src/widgets/box_button.dart';

class ReminderPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ReminderPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 5, minute: 20);
  bool _isReminderEnabled = false;
  Set<int> _selectedDays = {};
  List<Map<String, dynamic>> _selectedTimes = [];

  String _getDayDescription(Set<int> days) {
    if (days.isEmpty) return 'No days selected';
    if (days.length == 7) return 'Every day';

    if (days.containsAll([2, 3, 4, 5, 6])) {
      if (days.length == 5) return 'Weekdays';
    }

    if (days.containsAll([6, 7])) {
      if (days.length == 2) return 'Weekend';
    }

    List<int> sortedDays = days.toList()..sort();
    List<String> dayNames = sortedDays.map((day) {
      switch (day) {
        case 1:
          return 'Mon';
        case 2:
          return 'Tue';
        case 3:
          return 'Wed';
        case 4:
          return 'Thu';
        case 5:
          return 'Fri';
        case 6:
          return 'Sat';
        case 7:
          return 'Sun';
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
          child: Container(
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

    if (result != null &&
        result.containsKey('time') &&
        result.containsKey('days')) {
      setState(() {
        if (isNew) {
          _selectedTimes.add({'time': result['time'], 'days': result['days']});
        } else {
          _selectedTimes[index!] = {
            'time': result['time'],
            'days': result['days']
          };
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.onSecondary,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  right: 24.0,
                  left: 24.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onBackground,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text('Reminder',
                        style:
                            h2.copyWith(color: theme.colorScheme.onBackground)),
                    Opacity(
                      opacity: 0.0,
                      child: IgnorePointer(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSwitch(
                title: 'Reminder',
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
              ),
              Container(
                width: 380,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: Color(0xFF8D8E99),
                    ),
                  ),
                ),
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
                            subtitle: _getDayDescription(entry.value['days']),
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
      bottomNavigationBar: CustomBottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSetupReminderPage(context, isNew: true);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient,
          ),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 24,
              color: active,
            ),
          ),
        ),
      ),
    );
  }
}

class _SetupReminderWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final TimeOfDay initialTime;
  final Set<int> initialDays;
  final bool showDeleteButton;

  const _SetupReminderWidget({
    Key? key,
    this.scrollController,
    required this.initialTime,
    required this.initialDays,
    required this.showDeleteButton,
  }) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text('Setup Reminder', style: h3.copyWith(color: Colors.white)),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, {'time': _selectedTime, 'days': _selectedDays});
              },
              child: Text(
                'Save',
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
              title: Text('Reminder Time'),
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
              title: Text('Loop Reminder'),
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
                        [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun'
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
                child: BoxButton(
                  title: 'Delete Reminder',
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
