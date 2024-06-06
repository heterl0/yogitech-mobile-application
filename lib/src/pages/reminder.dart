import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/widgets/switch.dart';
import 'package:yogi_application/src/pages/setup_reminder.dart';

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
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
                          icon: Icon(Icons.add), // Placeholder icon
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
              CustomSwitch(
                title: 'Reminder Time',
                subtitle: _selectedTime.format(context),
                value: _isReminderEnabled,
                onChanged: (value) {
                  setState(() {
                    _isReminderEnabled = value;
                  });
                  if (value) {
                    _selectTime(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSetupReminderPage(context);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: gradient, // Áp dụng gradient từ app_colors.dart
          ),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 24,
              color: active, // Sử dụng màu sắc active từ app_colors.dart
            ),
          ),
        ),
      ),
    );
  }

  void _showSetupReminderPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Chiều cao ban đầu của bottom sheet
          minChildSize: 0.2, // Chiều cao tối thiểu của bottom sheet
          maxChildSize: 1.0, // Chiều cao tối đa của bottom sheet
          expand: false, // Cho phép mở rộng bottom sheet khi kéo
          builder: (context, scrollController) {
            return SetupReminderPage(scrollController: scrollController);
          },
        );
      },
    );
  }
}
