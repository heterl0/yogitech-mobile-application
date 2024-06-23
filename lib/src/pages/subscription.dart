import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/pages/payment_history.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pay/pay.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  late final Future<PaymentConfiguration> _googlePayConfigFuture;
  // final _paymentItems = [
  //   PaymentItem(
  //     label: 'Weekly subscription',
  //     amount: '0.01',
  //     status: PaymentItemStatus.final_price,
  //   ),
  //   PaymentItem(
  //     label: 'Monthly subscription',
  //     amount: '0.1',
  //     status: PaymentItemStatus.final_price,
  //   ),
  //   PaymentItem(
  //     label: 'Yearly subscription',
  //     amount: '1',
  //     status: PaymentItemStatus.final_price,
  //   ),
  // ];

  final paymentItems = [
    {
      'id': 0,
      'label': 'onceAWeek',
      "image": "assets/images/Universe.png",
      "gem": "199",
      "price": "109,000đ",
    },
    {
      'id': 1,
      'label': 'onceAMonth',
      "image": "assets/images/MoonPhase.png",
      "gem": "999",
      "price": "399,000đ",
    },
    {
      'id': 2,
      'label': 'onceAYear',
      "image": "assets/images/Sun.png",
      "gem": "9,999",
      "price": "3,999,000đ",
    },
  ];

  // late _paymentSelected;

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');

    // fetchData();
  }

  // Future<void> fetchData() async {
  //   final data =
  //       await PaymentConfiguration.fromAsset('default_google_pay_config.json');
  //   print(data.toString());
  // }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 50,
              child: Image.asset('assets/images/Emerald.png'),
            ),
            Text(
              '5',
              style: h3.copyWith(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        postActions: [
          IconButton(
            icon: Icon(Icons.history, color: theme.colorScheme.onSurface),
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
        buttonTitle: trans.subscription,
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
          // ..._paymentItems.map((e) => _buildPlanOptionContainer(e)).toList(),
          _buildPlanOptionContainer(),
          const SizedBox(height: 16),
          _buildPlanOptionContainer2(),
          const SizedBox(height: 16),
          _buildPlanOptionContainer3(),
          const SizedBox(height: 16),
          // FutureBuilder<PaymentConfiguration>(
          //   future: _googlePayConfigFuture,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return GooglePayButton(
          //         paymentConfiguration: snapshot.data!,
          //         paymentItems: _paymentItems,
          //         type: GooglePayButtonType.buy,
          //         margin: const EdgeInsets.only(top: 15.0),
          //         onPaymentResult: onGooglePayResult,
          //         loadingIndicator: const Center(
          //           child: CircularProgressIndicator(),
          //         ),
          //       );
          //     } else {
          //       return const SizedBox.shrink();
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlanContainer() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            trans.currentPlan,
            style: h3.copyWith(color: theme.colorScheme.onPrimary),
          ),
          SizedBox(height: 8),
          Text(
            trans.waitToEndPlan,
            style: bd_text.copyWith(color: text),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUnSubscriptionContainer() {
    Theme.of(context);
    final trans = AppLocalizations.of(context)!;

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
          SizedBox(
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
                          trans.onceAMonth,
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
                  trans.unsubscription,
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
    final trans = AppLocalizations.of(context)!;

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
              SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    'assets/images/MoonPhase2.png',
                  )),
              const SizedBox(height: 12),
              Text(
                trans.wantToUnsubscribe,
                textAlign: TextAlign.center,
                style: h2.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 16),
              CustomButton(
                  title: trans.unsubscription, style: ButtonStyleType.Primary),
              const SizedBox(height: 16),
              CustomButton(
                  title: trans.cancel,
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
    final trans = AppLocalizations.of(context)!;

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
                trans.onceAYear,
                textAlign: TextAlign.center,
                style:
                    h2.copyWith(color: theme.colorScheme.onPrimary, height: 1),
              ),
              const SizedBox(height: 16),
              Text(
                trans.subscriptionBy,
                style: bd_text.copyWith(color: text),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              CustomButton(title: '3.999.999đ', style: ButtonStyleType.Primary),
              const SizedBox(height: 16),
              CustomButton(
                  title: '9.999 gems', style: ButtonStyleType.Secondary),
              const SizedBox(height: 16),
              CustomButton(
                title: trans.cancel,
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
    final trans = AppLocalizations.of(context)!;

    return SizedBox(
      height: 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              trans.choosePlan,
              textAlign: TextAlign.center,
              style: h3.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(trans.unlockPremium,
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
    final trans = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
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
                        trans.onceAWeek,
                        textAlign: TextAlign.center,
                        style: min_cap.copyWith(
                            color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
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
                                      '199',
                                      style: h3.copyWith(
                                          color: theme.colorScheme.onPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              trans.locale == "en" ? "or" : "hoặc",
                              style: bd_text.copyWith(color: text),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '109,000đ',
                              // item.amount,
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
        ),
        // const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlanOptionContainer2() {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

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
                    trans.onceAMonth,
                    textAlign: TextAlign.center,
                    style: min_cap.copyWith(color: theme.colorScheme.onSurface),
                    // style: TextStyle(
                    //   color: Colors.white,
                    //   fontSize: 10,
                    //   fontFamily: 'Readex Pro',
                    //   fontWeight: FontWeight.w400,
                    //   height: 0.12,
                    // ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
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
                                  style: h3.copyWith(
                                      color: theme.colorScheme.onPrimary),
                                  // style: TextStyle(
                                  //   color: Colors.white,
                                  //   fontSize: 16,
                                  //   fontFamily: 'Readex Pro',
                                  //   fontWeight: FontWeight.w600,
                                  //   height: 0.06,
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          trans.locale == "en" ? "or" : "hoặc",
                          style: bd_text.copyWith(color: text),
                          // textAlign: TextAlign.center,
                          // style: TextStyle(
                          //   color: Color(0xFF8D8E99),
                          //   fontSize: 10,
                          //   fontFamily: 'Readex Pro',
                          //   fontWeight: FontWeight.w400,
                          //   height: 0.12,
                          // ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '399,000đ',
                          textAlign: TextAlign.center,
                          style: h3.copyWith(color: primary),

                          // style: TextStyle(
                          //   color: Color(0xFF4094CF),
                          //   fontSize: 16,
                          //   fontFamily: 'Readex Pro',
                          //   fontWeight: FontWeight.w600,
                          //   height: 0.06,
                          // ),
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
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

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
                    trans.onceAYear,
                    textAlign: TextAlign.center,
                    style: min_cap.copyWith(color: theme.colorScheme.onSurface),
                    // style: TextStyle(
                    //   color: Colors.white,
                    //   fontSize: 10,
                    //   fontFamily: 'Readex Pro',
                    //   fontWeight: FontWeight.w400,
                    //   height: 0.12,
                    // ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
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
                                width: 52,
                                child: Text(
                                  '9,999',
                                  style: h3.copyWith(
                                      color: theme.colorScheme.onPrimary),
                                  // style: TextStyle(
                                  //   color: Colors.white,
                                  //   fontSize: 16,
                                  //   fontFamily: 'Readex Pro',
                                  //   fontWeight: FontWeight.w600,
                                  //   height: 0.06,
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          trans.locale == "en" ? "or" : "hoặc",
                          style: bd_text.copyWith(color: text),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '3,999,000đ',
                          textAlign: TextAlign.center,
                          style: h3.copyWith(color: primary),

                          // style: TextStyle(
                          //   color: Color(0xFF4094CF),
                          //   fontSize: 16,
                          //   fontFamily: 'Readex Pro',
                          //   fontWeight: FontWeight.w600,
                          //   height: 0.06,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
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
