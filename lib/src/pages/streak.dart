import 'package:flutter/material.dart';

class Streak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Color(0xFF09141C)),
      child: Stack(
        children: [
          _buildTopRoundedContainer(),
          _buildTitleText(context),
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildTopRoundedContainer() {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Color(0xFF0D1F29),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          top: 78,
          child: Text(
            'Streak',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 70,
          child: _buildBackButton(context),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      left: 24,
      top: 150,
      right: 24,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(), // Placeholder, có thể thay đổi nếu cần
            SizedBox(height: 24),
            _buildStreakContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakContainer() {
    return Container(
      width: 312,
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStreakInfo(),
          const SizedBox(height: 16),
          _buildMonthInfo(),
          const SizedBox(height: 16),
          _buildAdditionalInfo(),
          const SizedBox(height: 16),
          _buildPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildStreakInfo() {
    return Container(
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStreakText(),
              _buildStreakImage(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakText() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Text(
              '256',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4094CF),
                fontSize: 48,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w700,
                height: 0.01,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'day streak!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8D8E99),
                fontSize: 12,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakImage() {
    return Container(
      width: 120,
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 77,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset('assets/images/Fire.png').image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthInfo() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter, // Add this line
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'May 2024',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w700,
              height: 0.04,
            ),
          ),
          Row(
            children: [
              _buildMonthControl(),
              const SizedBox(width: 16),
              _buildMonthControl(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthControl() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard(
          '30 days',
          'practiced in month',
          LinearGradient(
            begin: Alignment(0.91, -0.41),
            end: Alignment(-0.91, 0.41),
            colors: [
              Color(0xFF3BE2B0),
              Color(0xFF4095D0),
              Color(0xFF5986CC),
            ],
          ),
        ),
        _buildInfoCard(
          'Feb 14',
          'Begin of the streak',
          null,
          borderColor: Color(0x7FA4B7BD),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, Gradient? gradient,
      {Color? borderColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          gradient: gradient,
          color: gradient == null ? Color(0xFF09141C) : null,
          shape: RoundedRectangleBorder(
            side: borderColor != null
                ? BorderSide(width: 1, color: borderColor)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w600,
                height: 0.06,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w400,
                height: 0.12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 312,
      height: 280,
      decoration: BoxDecoration(color: Color(0xFF8D8E99)),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      right: 13,
      top: 70,
      child: IconButton(
        icon: Image.asset('assets/icons/close.png',
            color: Colors.white, width: 25, height: 25),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
