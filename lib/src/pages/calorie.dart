import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    FlSpot(0, 2000), // x = thời gian (ví dụ: ngày), y = kinh nghiệm
    FlSpot(1, 2200),
    FlSpot(2, 2400),
    FlSpot(3, 2600),
    FlSpot(4, 2800),
    FlSpot(5, 3000),
  ];

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStreakInfo(context),
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

  Widget _buildMonthInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'May 2024',
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
      onPressed: () {},
    );
    // return Container(
    //   width: 27,
    //   height: 27,
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage('assets/icons/arrow_back_ios.png'),
    //     ),
    //   ),
    // );
  }

  Widget _buildMonthControlForward() {
    // return Container(
    //   width: 27,
    //   height: 27,
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage('assets/icons/arrow_forward_ios.png'),
    //     ),
    //   ),
    // );
    return IconButton(
      icon: Icon(
        Icons.chevron_right,
        size: 36,
        color: stroke,
      ),
      onPressed: () {},
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
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
                    '800 cal',
                    style: h3.copyWith(color: active, height: 1.2),
                  ),
                  Text(
                    trans.burnedInMonth,
                    style: min_cap.copyWith(
                      color: active,
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
    return Padding(
      padding: EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: LineChart(LineChartData(
          minX: 0,
          maxX: 5,
          minY: 1000,
          maxY: 3000,
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
                    return Text(
                      value.toString(),
                      style: min_cap.copyWith(color: text),
                      textAlign: TextAlign.center,
                    );
                  },
                  showTitles: true,
                  reservedSize: 48),
            ),
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
        )),
      ),
    );
  }
}
