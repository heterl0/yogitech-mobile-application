import 'package:flutter/material.dart';

class SetupReminderPage extends StatefulWidget {
  const SetupReminderPage({Key? key}) : super(key: key);

  @override
  _SetupReminderPageState createState() => _SetupReminderPageState();
}

class _SetupReminderPageState extends State<SetupReminderPage> {
  bool _loopEnabled = false;
  TimeOfDay _selectedTime = TimeOfDay(hour: 5, minute: 20);
  Set<int> _selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Setup Reminder'), // Tiêu đề trang
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng màn hình khi không thao tác
                  },
                  child: Text('Cancel'), // Thay thế icon bằng chữ Cancel
                ),
                SizedBox(width: 10), // Khoảng cách giữa Cancel và Save
                TextButton(
                  onPressed: () {
                    // Lưu thay đổi và trở về trang Reminder
                    _saveReminder();
                    Navigator.pop(context);
                  },
                  child: Text('Save'), // Thay thế icon bằng chữ Save
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Phần Timer Picker để chọn thời gian
            Text(
              'Select Time:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            _buildTimePicker(),

            // Phần Loop để chọn ngày
            SizedBox(height: 20.0),
            Text(
              'Loop:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            _buildLoopDays(),

            // Nút Delete Reminder
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Xóa reminder và trở về trang Reminder
                _deleteReminder();
                Navigator.pop(context);
              },
              child: Text('Delete Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget để chọn thời gian
  Widget _buildTimePicker() {
    return InkWell(
      onTap: () {
        _selectTime(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Time: ${_selectedTime.format(context)}',
              style: TextStyle(fontSize: 16.0),
            ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  // Widget để chọn ngày
  Widget _buildLoopDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Nút Toggle Loop
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Loop Reminder:'),
            Switch(
              value: _loopEnabled,
              onChanged: (value) {
                setState(() {
                  _loopEnabled = value;
                  if (!_loopEnabled) {
                    // Nếu tắt Loop, xóa tất cả các ngày đã chọn
                    _selectedDays.clear();
                  }
                });
              },
            ),
          ],
        ),
        // Các ngày trong tuần
        Wrap(
          spacing: 10.0,
          children: [
            for (int i = 1; i <= 7; i++)
              FilterChip(
                label: Text('T$i'),
                selected: _selectedDays.contains(i),
                onSelected: _loopEnabled
                    ? (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(i);
                          } else {
                            _selectedDays.remove(i);
                          }
                        });
                      }
                    : null, // Không cho phép chọn nếu Loop bị tắt
              ),
          ],
        ),
      ],
    );
  }

  // Phương thức hiển thị TimePicker để chọn thời gian
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

  void _saveReminder() {}
  void _deleteReminder() {
  }
}

    //
