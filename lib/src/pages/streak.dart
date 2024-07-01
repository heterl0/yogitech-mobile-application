import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Streak extends StatefulWidget {
  const Streak({super.key});

  @override
  _StreakState createState() => _StreakState();
}

class _StreakState extends State<Streak> {
  DateTime _currentDate = DateTime.now();
  DateTime? _lastStreakStartDate;
  late dynamic streakData;

  @override
  void initState() {
    _fetchStreakData();
    super.initState();
  }

  Future<void> _fetchStreakData() async {
    // Call API to fetch streak data
    final data = await getStreakInMonth(6, 2024);
    print(data);
    setState(() {
      streakData = data;
    });
  }

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
    return DateUtils.getDaysInMonth(year, month);
  }

  //Ngày tập được Generate từ hàm này
  List<DateTime> _generateStreakData() {
    List<DateTime> streakDays = [];
    int daysInMonth = _getDaysInMonth(_currentDate.year, _currentDate.month);

    // Assuming a streak of exercising on weekdays (Monday to Friday)
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(_currentDate.year, _currentDate.month, i);
      // Check if the day is a weekday (Monday to Friday)
      if (day.weekday >= DateTime.monday && day.weekday <= DateTime.friday) {
        streakDays.add(day);
      }
    }

    // Determine the start date of the last streak if streakDays is not empty
    _lastStreakStartDate = streakDays.isNotEmpty ? streakDays.first : null;

    return streakDays;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: trans.streak,
        showBackButton: false,
        postActions: [
          IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
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
    final trans = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                _buildStreakInfo(trans),
                SizedBox(height: 16),
                _buildMonthInfo(context),
                SizedBox(height: 16),
                _buildAdditionalInfo(context),
                SizedBox(height: 16),
                _buildCalendar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakInfo(AppLocalizations trans) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: _buildStreakText(trans),
        ),
        Expanded(
          flex: 1,
          child: _buildStreakImage(),
        )
      ],
    );
  }

  Widget _buildStreakText(AppLocalizations trans) {
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
          trans.dayStreak,
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
            DateFormat('MMMM y', Localizations.localeOf(context).toString())
                .format(_currentDate),
            style: h2.copyWith(color: theme.colorScheme.onSurface),
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
    final trans = AppLocalizations.of(context)!;

    List<DateTime> streakDays = _generateStreakData();
    int streakDaysCount = streakDays.length;

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
                    '$streakDaysCount ${(streakDaysCount == 1) && (trans.locale == "en") ? "day" : trans.days}',
                    style: h3.copyWith(color: active, height: 1.2),
                  ),
                  Text(
                    trans.locale == "en"
                        ? 'in this month.'
                        : 'trong tháng này.',
                    style: min_cap.copyWith(
                      color: active,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
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
                    _lastStreakStartDate != null
                        ? DateFormat.yMMMd(
                                Localizations.localeOf(context).toString())
                            .format(_lastStreakStartDate!)
                        : 'N/A',
                    style: h3.copyWith(
                        color: theme.colorScheme.onPrimary, height: 1.2),
                  ),
                  Text(
                    trans.beginOfTheStreak,
                    style: min_cap.copyWith(
                      color: theme.colorScheme.onSurface,
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

  Widget _buildCalendar(BuildContext context) {
    List<DateTime> streakDays = _generateStreakData();
    int daysInMonth = _getDaysInMonth(_currentDate.year, _currentDate.month);
    int firstWeekdayOfMonth =
        DateTime(_currentDate.year, _currentDate.month, 1).weekday;

    List<Widget> calendarWidgets = [];

    // Hiển thị thứ trong tuần theo bản địa hóa
    for (int i = 3; i <= 9; i++) {
      final dayOfWeek = DateFormat.E(Localizations.localeOf(context).toString())
          .format(DateTime(2024, 6, i)); // Lấy thứ tự từ T2 -> CN
      calendarWidgets.add(
        Center(
          child: Text(dayOfWeek, style: bd_text.copyWith(color: text)),
        ),
      );
    }

    for (int i = 1; i < firstWeekdayOfMonth; i++) {
      calendarWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(_currentDate.year, _currentDate.month, day);
      bool isStreakDay = streakDays.contains(date);
      calendarWidgets.add(_buildCalendarDay(date, isStreakDay));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: calendarWidgets,
    );
  }

  Widget _buildCalendarDay(DateTime date, bool isStreakDay) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: isStreakDay ? primary : stroke),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          style: bd_text.copyWith(
              color: isStreakDay ? primary : theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
