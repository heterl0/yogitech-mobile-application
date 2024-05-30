import 'package:flutter/material.dart';

class Streak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A141C),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buildBody(context),
        bottomNavigationBar: _buildNavigationBar(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0A141C)),
      child: Stack(
        children: [
          _buildTopRoundedContainer(),
          _buildTitleText(context),
          Positioned.fill(
            child: SingleChildScrollView(
              child: _buildMainContent(),
            ),
          ),
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
        height: 150,
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
          top: 100,
          child: Text(
            'Streak',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          right: 15,
          top: 92,
          child: _buildCloseButton(context),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/close.png',
        color: Colors.white.withOpacity(1),
        width: 30,
        height: 30,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                _buildStreakInfo(),
                _buildMonthInfo(),
                SizedBox(height: 20),
                _buildAdditionalInfo(),
                SizedBox(height: 20),
                _buildPlaceholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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
        padding: const EdgeInsets.only(top: 1, left: 0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Color(0xFF3BE2B0),
                          Color(0xFF4095D0),
                          Color(0xFF5986CC)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        '256',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w900,
                          height: 1.0, // Adjust as needed
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1),
            Text(
              'day streak!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8D8E99),
                fontSize: 12,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w400,
                height: 1.0,
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
      padding: const EdgeInsets.fromLTRB(15, 5, 20, 8),
      child: Container(
        width: 80,
        height: 77,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Fire.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0), // Adjust the value as needed
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'May 2024',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w900,
                height: 0.04,
              ),
            ),
            Row(
              children: [
                _buildMonthControlBack(),
                SizedBox(width: 20),
                _buildMonthControlForward(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthControlBack() {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/arrow_back.png'),
        ),
      ),
    );
  }

  Widget _buildMonthControlForward() {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/arrow_forward.png'),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 170,
              height: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3BE2B0),
                    Color(0xFF4095D0),
                    Color(0xFF5986CC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(16), // This will round the corners
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 18, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '30 days',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w700,
                          height: 0.05,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'practiced in month',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w500,
                          height: 0.12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 170,
              height: 65,
              decoration: BoxDecoration(
                color: Color(0xFF0D1F29),
                borderRadius:
                    BorderRadius.circular(16), // This will round the corners
                border: Border.all(
                  color: Colors.white, // Border color
                  width: 0.6, // Border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 18, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Feb 14',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w700,
                          height: 0.05,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'begin of the streak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w500,
                          height: 0.12,
                        ),
                      ),
                    ),
                  ],
                ),
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

Widget _buildNavigationBar() {
  return Container(
    height: 100,
    child: Stack(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFF0D1F29),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavItem(
                  label: 'Home',
                  icon: 'assets/icons/grid_view.png',
                  isSelected: true,
                ),
                _buildNavItem(
                  label: 'Blog',
                  icon: 'assets/icons/newsmode.png',
                  isSelected: false,
                ),
                _buildNavItem(
                  label: 'Activities',
                  icon: 'assets/icons/exercise.png',
                  isSelected: false,
                ),
                _buildNavItem(
                  label: 'Meditate',
                  icon: 'assets/icons/self_improvement.png',
                  isSelected: false,
                ),
                _buildNavItem(
                  label: 'Profile',
                  icon: 'assets/icons/account_circle.png',
                  isSelected: false,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildNavItem({
  required String label,
  required String icon,
  required bool isSelected,
}) {
  return GestureDetector(
    onTap: () {
      print('Navigated to $label');
    },
    child: Column(
      children: [
        Image.asset(
          icon,
          color: isSelected ? Color(0xFF4094CF) : Color(0xFF8D8E99),
          width: 24,
          height: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Color(0xFF4094CF) : Color(0xFF8D8E99),
            fontSize: 10,
            fontFamily: 'Readex Pro',
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
      ],
    ),
  );
}
