import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart'; // Thêm package này để format ngày tháng

class Calorie extends StatefulWidget {
  const Calorie({super.key});

  @override
  State<Calorie> createState() => _CalorieState();
}

class _CalorieState extends State<Calorie> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: trans.calorie,
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: _buildMainContent(context),
    );
  }

  List<FlSpot> sampleDataCalorie = [
    FlSpot(0, 3000),
    FlSpot(1, 2200),
    FlSpot(2, 2400),
    FlSpot(3, 2600),
    FlSpot(4, 2800),
    FlSpot(5, 4000),
    FlSpot(6, 0),
  ];

  final List<DateTime> dates = List.generate(
      7, (index) => DateTime.now().subtract(Duration(days: 6 - index)));

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
                _buildStreakInfo(context),
                SizedBox(height: 16),
                Text(
                  trans.burnInThisWeek,
                  style: h3.copyWith(color: primary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _buildChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: _buildStreakImage(),
        ),
        Expanded(
          flex: 2,
          child: _buildStreakText(context),
        ),
      ],
    );
  }

  Widget _buildStreakText(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return gradient.createShader(bounds);
          },
          child: const Text(
            "12800",
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
          trans.caloriesBurnedInMonth,
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
          image: AssetImage('assets/images/Muscle.png'),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: LineChart(LineChartData(
          minX: 0,
          maxX: 6,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: stroke,
                strokeWidth: 1,
              );
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: sampleDataCalorie,
              isCurved: true,
              gradient: gradient,
              barWidth: 4,
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toString(),
                    style: min_cap.copyWith(color: text),
                    textAlign: TextAlign.center,
                  );
                },
                reservedSize: 60,
                showTitles: true,
              ),
            ),
            bottomTitles: AxisTitles(
              drawBelowEverything: true,
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) {
                  final date = dates[value.toInt()];
                  final formattedDate = DateFormat('dd/MM').format(date);
                  return Text(
                    formattedDate,
                    style: min_cap.copyWith(color: text),
                    textAlign: TextAlign.center,
                  );
                },
                showTitles: true,
                reservedSize: 48,
              ),
            ),
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
        )),
      ),
    );
  }
}
