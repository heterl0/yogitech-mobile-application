import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

class Calorie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Calorie",
        showBackButton: true,
        onBackPressed: () {
          Navigator.pop(context);
        },
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
              // mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
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
          flex: 1,
          child: _buildStreakImage(),
        ),
        Expanded(
          flex: 2,
          child: _buildStreakText(),
        ),
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
          'calories burned',
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
          image: AssetImage('assets/images/Union.png'),
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
    final theme = Theme.of(context);
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
                    'burned in this month',
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
