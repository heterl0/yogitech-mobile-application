import 'dart:ffi';

import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/api/subscription/subscription_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:YogiTech/src/custombar/bottombar.dart';
import 'package:YogiTech/src/pages/payment_history.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';

class SubscriptionPage extends StatefulWidget {
  final Account? account;
  final VoidCallback? fetchAccount;
  const SubscriptionPage({super.key, this.account, this.fetchAccount});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<SubscriptionPage> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;
  List<dynamic> _subs = [];
  List<dynamic> _userSubs = [];
  UserSubscription? _currendSub;
  Subscription? _selectedSub;
  Account? _account;
  bool _isLoading = true;

  // late _paymentSelected;

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
    _loadSub();
    _account = widget.account;
  }

  Future<void> _loadSub() async {
    try {
      final sub = await getSubscriptions();
      final ussub = await getUserSubscriptions();
      setState(() {
        _subs = sub;
        _userSubs = ussub;
        _isLoading = false;
        print('asd');
        print(_userSubs);
        if (_userSubs.length > 0 &&
            _userSubs[_userSubs.length - 1]?.activeStatus != 0) {
          
          _currendSub = checkExpire(_userSubs[_userSubs.length - 1])? null:_userSubs[_userSubs.length - 1];
        }
      });
    } catch (e) {
      // Handle errors, e.g., show a snackbar or error message
      print('Error loading Subscription: $e');
    }
  }

  Future<void> _loadUserSub() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final sub = await getUserSubscriptions();
      setState(() {
        _userSubs = sub;
        _isLoading = false;

        if (_userSubs.length > 0 &&
            _userSubs[_userSubs.length - 1]?.activeStatus != 0) {
            _currendSub = _userSubs[_userSubs.length - 1];
        }else{
          _currendSub=null;
        }
      });
    } catch (e) {
      print('Error loading UserSubscription: $e');
    }
  }

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
                (_account!.profile.point).toString(),
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
                    builder: (context) => PaymentHistory(userSubs:_userSubs,subs:_subs),
                  ),
                );
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildBody(context),
        bottomNavigationBar: _buildBottomBar(context));
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentPlanContainer(),
          const SizedBox(height: 16),
          _buildUnSubscriptionContainer(),
          const SizedBox(height: 16),
          _buildChoosePlanContainer(),
          const SizedBox(height: 16),
          // ..._paymentItems.map((e) => _buildPlanOptionContainer(e)).toList(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _subs.length,
              itemBuilder: (context, index) {
                return _buildPlanOptionContainer(_subs[index]);
              },
            ),
          ),
          // _buildPlanOptionContainer(),
          // const SizedBox(height: 16),
          // _buildPlanOptionContainer2(),
          // const SizedBox(height: 16),
          // _buildPlanOptionContainer3(),
          // const SizedBox(height: 16),
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
      child: _currendSub != null
          ? Column(
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
            )
          : Column(),
    );
  }

  Widget _buildUnSubscriptionContainer() {
    Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    if (_currendSub != null) {
      Subscription sub = _subs.firstWhere(
        (sub) => sub.id == _currendSub!.subscriptionId,
        orElse: () => null,
      );
      final local = Localizations.localeOf(context);
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.parse('${_currendSub?.expireDate}');

      String startDay = DateFormat.yMMMd(local.languageCode)
          .format(DateTime.parse('${_currendSub?.createdAt}'));
      String endDay = DateFormat.yMMMd(local.languageCode).format(endDate);
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
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: sub!.durationInMonth < 1
                            ? AssetImage('assets/images/Universe2.png')
                            : (sub.durationInMonth >= 12
                                ? AssetImage('assets/images/Sun2.png')
                                : AssetImage('assets/images/MoonPhase2.png')),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ' ${convertDuration(sub.durationInMonth, trans.locale)}',
                                style: bd_text.copyWith(color: Colors.white),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trans.start + ': $startDay',
                                    style: min_cap.copyWith(color: active),
                                  ),
                                  Text(
                                    trans.end + ': $endDay',
                                    style: min_cap.copyWith(color: active),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
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
                                      child: Text(
                                        _currendSub?.subscriptionType == 1
                                            ? '${sub.gemPrice}'
                                            : '${sub.price.toInt().toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')} VND',
                                        style: h2.copyWith(color: active),
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
            Text(
              '${endDate.difference(now).inDays} ' + trans.eventRemain,
              style: h3.copyWith(color: active),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    } else {
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
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/MoonPhase2.png'),
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
                          Container(
                            child: SizedBox(
                              child: Text(
                                trans.locale == 'vi'
                                    ? 'Nâng cấp lên bản cao cấp để có các tính năng độc quyền và tối đa hóa trải nghiệm của bạn.'
                                    : "Unlock your full potential! Upgrade to premium for exclusive features and maximize your experience.",
                                style: h3.copyWith(color: active),
                              ),
                            ),
                          ),
                        ],
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
  }

  Future<void> _unsubscriptionBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    Subscription sub = _subs.firstWhere(
      (sub) => sub.id == _currendSub!.subscriptionId,
      orElse: () => null,
    );
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
                child: sub.durationInMonth < 1
                    ? Image.asset('assets/images/Universe2.png')
                    : (sub.durationInMonth >= 12
                        ? Image.asset('assets/images/Sun2.png')
                        : Image.asset('assets/images/MoonPhase2.png')),
              ),
              const SizedBox(height: 12),
              Text(
                trans.wantToUnsubscribe,
                textAlign: TextAlign.center,
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              Text(
                trans.unsubDetail,
                textAlign: TextAlign.center,
                style: bd_text.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 16),
              CustomButton(
                title: trans.unsubscription,
                style: ButtonStyleType.Quaternary,
                onPressed: () async {
                  if (_currendSub != null) {
                    int subscriptionId = _currendSub!.id!;
                    try {
                      final userSubscription =
                          await cancelSubscription(subscriptionId);
                      if (userSubscription != null) {
                        // widget.fetchAccount!();
                        // final account = await retrieveAccount();
                        setState(() {
                          _loadUserSub();
                          // _account = account;
                        });
                        Navigator.pop(context); // Close the bottom sheet
                      } else {
                        _showCustomPopup(context, 'Error',
                            'Subscription failed: User subscription is null');
                      }
                    } catch (error) {
                      _showCustomPopup(
                          context, trans.error, 'Subscription failed: $error');
                    }
                  } else {
                    _showCustomPopup(context, trans.error, trans.waitToEndPlan);
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                  title: trans.cancel,
                  style: ButtonStyleType.Secondary,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSubscriptionSheet(
      BuildContext context, Subscription sub) async {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final price = '${sub.price}';
    showModalBottomSheet(
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
                alignment: Alignment.center,
                child: sub.durationInMonth < 1
                    ? Image.asset(
                        'assets/images/Universe2.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : (sub.durationInMonth >= 12
                        ? Image.asset(
                            'assets/images/Sun2.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/MoonPhase2.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )),
              ),
              const SizedBox(height: 16),
              Text(
                convertDuration(sub.durationInMonth, trans.locale),
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
              CustomButton(title: price, style: ButtonStyleType.Primary),
              const SizedBox(height: 16),
              CustomButton(
                title: '${sub.gemPrice} gems',
                style: ButtonStyleType.Secondary,
                onPressed: () async {
                  if (_currendSub == null) {
                    int subscriptionId = sub.id;
                    try {
                      if ((_account?.profile.point)! >= sub.price) {
                        final userSubscription =
                            await subscribe(subscriptionId, 1);
                        if (userSubscription != null) {
                          widget.fetchAccount!();
                          final account = await retrieveAccount();
                          _loadUserSub();
                          setState(() {
                            _account = account;
                          });
                          Navigator.pop(context); // Close the bottom sheet
                        } else {
                          _showCustomPopup(context, 'Error',
                              'Subscription failed: User subscription is null');
                        }
                      } else {
                        trans.locale == 'en'
                            ? _showCustomPopup(context, 'Error',
                                'Not enough Gem for subscription.')
                            : _showCustomPopup(context, 'Lỗi',
                                'Bạn không có đủ Gem để đăng ký.');
                      }
                    } catch (error) {
                      _showCustomPopup(
                          context, trans.error, 'Subscription failed: $error');
                    }
                  } else {
                    _showCustomPopup(context, trans.error, trans.waitToEndPlan);
                  }
                },
              ),
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

  Widget _buildPlanOptionContainer(Subscription sub) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                image: sub.durationInMonth < 1
                    ? AssetImage('assets/images/Universe.png')
                    : (sub.durationInMonth >= 12
                        ? AssetImage('assets/images/Sun.png')
                        : AssetImage('assets/images/MoonPhase.png')),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  convertDuration(sub.durationInMonth, trans.locale),
                  textAlign: TextAlign.center,
                  style: min_cap.copyWith(color: theme.colorScheme.onSurface),
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
                              child: Text(
                                '${sub.gemPrice} ',
                                style: h3.copyWith(
                                    color: theme.colorScheme.onPrimary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        (sub.gemPrice != null && sub.price != null)
                            ? (trans.locale == "en" ? "or" : "hoặc")
                            : '',
                        style: bd_text.copyWith(color: text),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${sub.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VND',
                          style: h3.copyWith(color: primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildCheckboxItem(sub),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(Subscription sub) {
    bool value = (_selectedSub == sub);
    return Checkbox(
      activeColor: Color(0xFF0D1F29), // Background color when checked
      checkColor: Color(0xFF4095D0), // Tick color when checked
      value: value,

      onChanged: _currendSub != null
          ? null
          : (bool? value) {
              setState(() {
                if (value != null && value) {
                  _selectedSub = sub;
                } else {
                  _selectedSub = null;
                }
              });
            },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        child: BottomAppBar(
          elevation: appElevation,
          color: Theme.of(context).colorScheme.onSecondary,
          height: 100,
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: (_currendSub == null)
                      ? CustomButton(
                          title: trans.subscription,
                          style: ButtonStyleType.Primary,
                          state: _selectedSub != null
                              ? ButtonState.Enabled
                              : ButtonState.Disabled,
                          onPressed: () =>
                              {_showSubscriptionSheet(context, _selectedSub!)},
                        )
                      : CustomButton(
                          title: trans.unsubscription,
                          style: ButtonStyleType.Quaternary,
                          onPressed: () =>
                              {_unsubscriptionBottomSheet(context)},
                        ))),
        ));
  }

  void _showCustomPopup(BuildContext context, String title, String message) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface, // Custom background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Custom border radius
          ),
          title: Text(
            title,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.onSurface, // Custom title style
            ),
          ),
          content: Text(
            message,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface, // Custom content style
            ),
          ),
          actions: <Widget>[
            SizedBox(
              height: 12,
            ),
            CustomButton(
                title: trans.close,
                style: ButtonStyleType.Primary,
                onPressed: () => {Navigator.of(context).pop()}),
          ],
          contentPadding: EdgeInsets.symmetric(
              horizontal: 24, vertical: 20), // Custom content padding
          titlePadding: EdgeInsets.only(
              top: 20, left: 24, right: 24), // Custom title padding
        );
      },
    );
  }

  bool checkExpire(UserSubscription usub)  {
    DateTime now = DateTime.now();

    String? expireDateStr = usub.expireDate;
    if (expireDateStr != null) {
      DateTime endDate = DateTime.parse(expireDateStr);
      
      if (now.isAfter(endDate)) {
         expiredSubscription(usub.id!);
        return true;
      } 
    } else {
      print('Expire date is not set.');
    }
    return false;
  }

  String convertDuration(double durationInMonths, String local) {
    int years = (durationInMonths ~/ 12).toInt();
    int months = (durationInMonths % 12).toInt();
    int days =
        ((durationInMonths % 1) * 30).toInt(); // assuming 30 days in a month
    String duration = '';
    if (local == 'vi') {
      duration += (days > 0 ? '$days ngày ' : '');
      duration += (months > 0 ? '$months tháng ' : '');
      duration += (years > 0 ? '$years năm' : '');
    } else {
      duration += (days == 1
          ? '$days day '
          : days > 1
              ? '$days days '
              : '');
      duration += (months == 1
          ? '$months month '
          : months > 1
              ? '$months months '
              : '');
      duration += (years == 1
          ? '$years year'
          : years > 1
              ? '$years years'
              : '');
    }
    return duration;
  }

  Map<String, String> formatCurrency(double amount, String locale) {
    if (locale == 'vi') {
      // Vietnamese dong (VND)
      String formattedAmount =
          '${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VND';
      return {'amount': '$amount', 'curency': formattedAmount};
    } else if (locale == 'en') {
      // US Dollar ($)
      double usdAmount = amount / 23000;
      String formattedAmount = '\$${usdAmount.toStringAsFixed(2)}';
      return {'amount': '$usdAmount', 'curency': formattedAmount};
    } else {
      throw Exception('Unsupported locale: $locale');
    }
  }
}
