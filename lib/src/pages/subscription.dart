import 'package:flutter/material.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A141C),
      ),
      home: Scaffold(
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
          Positioned(
            left: 24,
            right: 24,
            top: 150,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom:
                      150), // Adding padding to ensure the button is visible
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildCurrentPlanContainer(),
                  const SizedBox(height: 16),
                  _buildSubscriptionContainer(),
                  const SizedBox(height: 16),
                  _buildChoosePlanContainer(),
                  const SizedBox(height: 16),
                  _buildPlanOptionContainer(),
                  const SizedBox(height: 16),
                  _buildPlanOptionContainer2(),
                  const SizedBox(height: 16),
                  _buildPlanOptionContainer3(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
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
          top: 105,
          child: Container(
            width: 68,
            height: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centering the content horizontally
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Emerald.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                    width: 8), // Add some spacing between logo and text
                Text(
                  '1.000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
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
      ),
      iconSize: 30,
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
      ),
      iconSize: 30,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCurrentPlanContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/MoonPhase.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
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
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Emerald.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
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
      height: 48,
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
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Unlock all premium exercises',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8D8E99),
                  fontSize: 12,
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptionContainer() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: ShapeDecoration(
        color: Color(0xFF09141C),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Universe.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/Emerald.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
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
                          '109,000đ',
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
          const SizedBox(width: 16),
          _buildCheckboxItem(
            value: _isChecked1,
            onChanged: (value) {
              setState(() {
                _isChecked1 = value!;
                if (value) {
                  _isChecked2 = false;
                  _isChecked3 = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptionContainer2() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: ShapeDecoration(
        color: Color(0xFF09141C),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/MoonPhase.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/Emerald.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
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
                          '399,000đ',
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
          const SizedBox(width: 16),
          _buildCheckboxItem(
            value: _isChecked2,
            onChanged: (value) {
              setState(() {
                _isChecked2 = value!;
                if (value) {
                  _isChecked1 = false;
                  _isChecked3 = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptionContainer3() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: ShapeDecoration(
        color: Color(0xFF09141C),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x7FA4B7BD)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Sun.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Once a year',
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
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/Emerald.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 42,
                                child: Text(
                                  '9,999',
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
                          '4,999,000đ',
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
          const SizedBox(width: 16),
          _buildCheckboxItem(
            value: _isChecked3,
            onChanged: (value) {
              setState(() {
                _isChecked3 = value!;
                if (value) {
                  _isChecked1 = false;
                  _isChecked2 = false;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Checkbox(
      activeColor: Color(0xFF0D1F29), // Background color when checked
      checkColor: Color(0xFF4095D0), // Tick color when checked
      value: value,
      onChanged: onChanged,
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
          ),
        ),
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
