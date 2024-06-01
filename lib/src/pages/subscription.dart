import 'package:flutter/material.dart';

class Subscription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A141C),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _buildBody(context),
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
          _buildMainContent(),
          _buildNavigationBar(),
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
            'Exercise detail',
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
          left: 15,
          top: 92,
          child: _buildBackButton(context),
        ),
        Positioned(
          right: 15,
          top: 92,
          child: _buildResetButton(context),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/arrow_back.png',
        color: Colors.white.withOpacity(1),
        width: 30,
        height: 30,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/device_reset.png',
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
    return Positioned(
      left: 0,
      right: 0,
      top: 150,
      bottom: 0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentPlanContainer(),
            const SizedBox(height: 16),
            _buildSubscriptionContainer(),
            const SizedBox(height: 16),
            _buildChoosePlanContainer(),
            const SizedBox(height: 16),
            _buildPlanOptionContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPlanContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your current plan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You have to wait to end this plan to subscribe to another plan',
            style: TextStyle(
              color: Color(0xFF8D8E99),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionContainer() {
    return Container(
      height: 124,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.91, -0.41),
          end: Alignment(-0.91, 0.41),
          colors: [Color(0xFF3BE2B0), Color(0xFF4095D0), Color(0xFF5986CC)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  child: FlutterLogo(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Once a month',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            height: 0.12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      child: FlutterLogo(),
                                    ),
                                    const SizedBox(width: 4),
                                    SizedBox(
                                      width: 42,
                                      child: Text(
                                        '999',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Readex Pro',
                                          fontWeight: FontWeight.w600,
                                          height: 0.06,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(44),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Unsubscription',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoosePlanContainer() {
    return Container(
      height: 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Choose a plan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w600,
                height: 0.06,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 16,
            child: Text(
              'Unlock all premium exercises',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8D8E99),
                fontSize: 12,
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptionContainer() {
    return Container(
      height: 248,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: Color(0xFF09141C),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  child: FlutterLogo(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Once a week',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Readex Pro',
                            fontWeight: FontWeight.w400,
                            height: 0.12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      child: FlutterLogo(),
                                    ),
                                    const SizedBox(width: 4),
                                    SizedBox(
                                      width: 42,
                                      child: Text(
                                        '199',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Readex Pro',
                                          fontWeight: FontWeight.w600,
                                          height: 0.06,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'or',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF8D8E99),
                                  fontSize: 10,
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 0.12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '109.000đ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF4094CF),
                                  fontSize: 16,
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w600,
                                  height: 0.06,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF0D1F29),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF09141C)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Positioned(
      left: 0,
      bottom: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFF0D1F29),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Center(
              child: _buildExerciseButton(),
            )),
      ),
    );
  }

  Widget _buildExerciseButton() {
    return Container(
      width: 324,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.91, -0.41),
          end: Alignment(-0.91, 0.41),
          colors: [Color(0xFF3BE2B0), Color(0xFF4095D0), Color(0xFF5986CC)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(44),
        ),
      ),
      child: Center(
        child: Text(
          'Subscription',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Readex Pro',
            fontWeight: FontWeight.w600,
            height: 0.06,
          ),
        ),
      ),
    );
  }
}
