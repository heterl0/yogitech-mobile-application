import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/pages/payment_history.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_button.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 50,
              child: Image.asset('assets/images/Emerald.png'),
            ),
            Text(
              '5',
              style: h3.copyWith(color: theme.colorScheme.onBackground),
            ),
          ],
        ),
        postActions: [
          IconButton(
            icon: Icon(Icons.history, color: theme.colorScheme.onBackground),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentHistory(),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomBar(
        buttonTitle: "Subscription",
        onPressed: () => _subscriptionBottomSheet(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildCurrentPlanContainer(),
          const SizedBox(height: 16),
          _buildUnSubscriptionContainer(),
          const SizedBox(height: 16),
          _buildChoosePlanContainer(),
          const SizedBox(height: 16),
          _buildPlanOptionContainer(),
          // const SizedBox(height: 16),
          // _buildPlanOptionContainer2(),
          // const SizedBox(height: 16),
          // _buildPlanOptionContainer3(),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanContainer() {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your current plan',
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
          SizedBox(height: 8),
          Text(
            'You have to wait to end this plan to subscribe to another plan',
            style: bd_text.copyWith(color: text),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUnSubscriptionContainer() {
    Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: gradient,
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
                          style: min_cap.copyWith(color: active),
                        ),
                        Row(
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
                                      style: h3.copyWith(color: active),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(44),
              ),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // _showChangePasswordDrawer(context);
                  _unsubscriptionBottomSheet(context);
                },
                child: Text(
                  'Unsubscription',
                  textAlign: TextAlign.center,
                  style: h3.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _unsubscriptionBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.onSecondary,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ), // Bo tròn góc
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    'assets/images/MoonPhase2.png',
                  )),
              const SizedBox(height: 12),
              Text(
                'Do you want to unsubscription?',
                textAlign: TextAlign.center,
                style: h2.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 16),
              BoxButton(
                  title: 'Unsubscription', style: ButtonStyleType.Primary),
              const SizedBox(height: 16),
              BoxButton(
                  title: 'Cancel',
                  style: ButtonStyleType.Tertiary,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _subscriptionBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    return showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.onSecondary,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                child: Center(
                  // Thêm widget Center
                  child: Image.asset(
                    'assets/images/Sun2.png',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Once a year',
                textAlign: TextAlign.center,
                style:
                    h2.copyWith(color: theme.colorScheme.onPrimary, height: 1),
              ),
              const SizedBox(height: 16),
              Text(
                'Subscription by',
                style: bd_text.copyWith(color: text),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              BoxButton(title: '4.999.999đ', style: ButtonStyleType.Primary),
              const SizedBox(height: 16),
              BoxButton(title: '9.999 gems', style: ButtonStyleType.Secondary),
              const SizedBox(height: 16),
              BoxButton(
                title: 'Cancel',
                style: ButtonStyleType.Tertiary,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChoosePlanContainer() {
    final theme = Theme.of(context);
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
              style: h3.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Unlock all premium exercises',
                  textAlign: TextAlign.center,
                  style: bd_text.copyWith(color: text)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptionContainer() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: stroke),
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
                    style:
                        min_cap.copyWith(color: theme.colorScheme.onBackground),
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
                                  style: h3.copyWith(
                                      color: theme.colorScheme.onPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'or',
                          style: bd_text.copyWith(color: text),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '109,000đ',
                          style: h3.copyWith(color: primary),
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
}
