import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:intl/intl.dart'; // Add this import

class Streak extends StatefulWidget {
  @override
  _StreakState createState() => _StreakState();
}

class _StreakState extends State<Streak> {
  DateTime _currentDate = DateTime.now(); // Initialize the current date

  void _incrementMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  void _decrementMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  int _getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29; // Leap year
      } else {
        return 28;
      }
    }
    return [4, 6, 9, 11].contains(month) ? 30 : 31;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Streak",
        showBackButton: false,
        postActions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onBackground),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              children: [
                _buildStreakInfo(),
                SizedBox(height: 16),
                _buildMonthInfo(context),
                SizedBox(height: 16),
                _buildAdditionalInfo(context),
                SizedBox(height: 16),
                _buildPlaceholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: _buildStreakText(),
        ),
        Expanded(
          flex: 1,
          child: _buildStreakImage(),
        )
      ],
    );
  }

  Widget _buildStreakText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return gradient.createShader(bounds);
          },
          child: const Text(
            "256",
            style: TextStyle(
              color: active,
              fontSize: 60,
              fontFamily: 'ReadexPro',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
        Text(
          'day streak!',
          textAlign: TextAlign.center,
          style: bd_text.copyWith(color: text),
        ),
      ],
    );
  }

  Widget _buildStreakImage() {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Fire.png'),
        ),
      ),
    );
  }

  Widget _buildMonthInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy')
                .format(_currentDate), // Use DateFormat to format the date
            style: h2.copyWith(color: theme.colorScheme.onBackground),
          ),
          Row(
            children: [
              _buildMonthControlBack(),
              _buildMonthControlForward(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthControlBack() {
    return IconButton(
      icon: Icon(
        Icons.chevron_left,
        size: 36,
        color: stroke,
      ),
      onPressed: _decrementMonth,
    );
  }

  Widget _buildMonthControlForward() {
    return IconButton(
      icon: Icon(
        Icons.chevron_right,
        size: 36,
        color: stroke,
      ),
      onPressed: _incrementMonth,
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final theme = Theme.of(context);
    int daysInMonth = _getDaysInMonth(_currentDate.year, _currentDate.month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$daysInMonth days',
                    style: h3.copyWith(color: active, height: 1.2),
                  ),
                  Text(
                    'in this month',
                    style: min_cap.copyWith(
                      color: active,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16), // Khoảng cách giữa hai Container
        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: stroke,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Feb 14',
                    style: h3.copyWith(
                        color: theme.colorScheme.onPrimary, height: 1.2),
                  ),
                  Text(
                    'begin of the streak',
                    style: min_cap.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(color: Color(0xFF8D8E99)),
        child: Column(
            // Add children widgets here
            ),
      ),
    );
  }
}
