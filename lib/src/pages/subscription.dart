import 'dart:ffi';

import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/api/subscription/subscription_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/models/subscriptions.dart';
import 'package:YogiTech/src/widgets/checkbox.dart';
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
import 'package:YogiTech/utils/formatting.dart' as format;

class SubscriptionPage extends StatefulWidget {
  final Account? account;
  final VoidCallback? fetchAccount;
  const SubscriptionPage({super.key, this.account, this.fetchAccount});

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<SubscriptionPage> {
  // late final Future<PaymentConfiguration> _googlePayConfigFuture;
  List<dynamic> _subs = [];
  List<dynamic> _userSubs = [];
  UserSubscription? _currendSub;
  String? _subStatus;

  Subscription? _selectedSub;
  Account? _account;
  bool _isLoading = true;

  // late _paymentSelected;

  @override
  void initState() {
    super.initState();
    // _googlePayConfigFuture =
    //     PaymentConfiguration.fromAsset('default_google_pay_config.json');
    _account = widget.account;
    _loadUserSub();
  }

  // UserSubscription _createFakeSubscription() {
  //   // Create a fake subscription
  //   final fakeSub = UserSubscription(
  //     id: -1,
  //     userId: _account!.id,
  //     subscriptionId: 3,
  //     subscriptionType: 1,
  //     status: 1,
  //     createdAt: DateTime.now().toString(),
  //     expireDate: DateTime.now().toString(),
  //     activeStatus: 1,
  //   );
  //   return fakeSub;
  // }

  Future<void> _loadUserSub() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final sub = await getSubscriptions();
      final ussub = await getUserSubscriptions();
      setState(() {
        _subs = sub;
        _userSubs = ussub;

        if ((_userSubs.length > 0)
          && (_userSubs[_userSubs.length - 1]?.activeStatus != 0 )
          && (_account!.is_premium!)) {
          _currendSub = _userSubs[_userSubs.length - 1];
          _subStatus = checkExpire(_currendSub!);
          if(_subStatus==null && _currendSub!.activeStatus !=0){
            makeSubExpire(_currendSub!);
            _currendSub = null;
          }
        } else {
          _currendSub = null;
        }
        _isLoading = false;
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
    return Scaffold(
        appBar: CustomAppBar(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: Image.asset('assets/images/Emerald.png'),
              ),
              SizedBox(
                width: 4,
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
                    builder: (context) =>
                        PaymentHistory(userSubs: _userSubs, subs: _subs),
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
    DateTime now = DateTime.now();
    final trans = AppLocalizations.of(context)!;
    if (_currendSub != null) {
      Subscription sub = _subs.firstWhere(
        (sub) => sub.id == _currendSub!.subscriptionId,
        orElse: () => null,
      );
      final local = Localizations.localeOf(context);

      String startDay = DateFormat('HH:mm dd/MM/yyyy')
          .format(DateTime.parse('${_currendSub?.createdAt}').toLocal());
      String endDay = DateFormat('HH:mm dd/MM/yyyy')
          .format(DateTime.parse('${_currendSub?.expireDate}').toLocal());
      return Container(
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            gradient: gradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Đảm bảo các phần tử trong Row có cùng chiều cao
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' ${convertDuration(sub.durationInMonth, trans.locale)}',
                      style: bd_text.copyWith(color: active),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: sub.durationInMonth < 1
                          ? Image.asset('assets/images/Universe_.png')
                          : (sub.durationInMonth >= 12
                              ? Image.asset('assets/images/Sun_.png')
                              : Image.asset('assets/images/MoonPhase_.png')),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Center(
                    child: Text(
                      '${_subStatus}',
                      style: h3.copyWith(color: active, height: 1),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/Emerald_.png'),
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
                            style: h3.copyWith(color: active),
                          ),
                        ),
                      ],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${trans.start}: ',
                            style: min_cap.copyWith(color: active),
                          ),
                          Text(
                            '$startDay',
                            style: min_cap.copyWith(color: active),
                          ),
                          Text(
                            '${trans.end}: ',
                            style: min_cap.copyWith(color: active),
                          ),
                          Text(
                            ' $endDay',
                            style: min_cap.copyWith(color: active),
                          ),
                        ]),
                  ],
                )
              ],
            ),
          ));
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
                        image: AssetImage('assets/images/MoonPhase.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            trans.upgradeYourSub,
                            style: h3.copyWith(color: active),
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
                    ? Image.asset('assets/images/Universe.png')
                    : (sub.durationInMonth >= 12
                        ? Image.asset('assets/images/Sun.png')
                        : Image.asset('assets/images/MoonPhase.png')),
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
                        widget.fetchAccount!();
                        final account = await retrieveAccount();
                        _loadUserSub();
                        setState(() {
                          _account = account;
                          print(_account);
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
                        'assets/images/Universe.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : (sub.durationInMonth >= 12
                        ? Image.asset(
                            'assets/images/Sun.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/MoonPhase.png',
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
                      if (sub.gemPrice != null &&
                          ((_account?.profile.point)! >= sub.gemPrice!)) {
                        final userSubscription =
                            await subscribe(subscriptionId, 1);
                        if (userSubscription != null) {
                          widget.fetchAccount!();
                          final account = await retrieveAccount();
                          setState(() {
                            _loadUserSub();
                            
                            _account = account;
                          });
                          Navigator.pop(context); // Close the bottom sheet
                        } else {
                          _showCustomPopup(context, 'Error',
                              'Subscription failed: User subscription is null');
                        }
                      } else {
                        if (!(sub.gemPrice != null)) {
                          trans.locale == 'en'
                              ? _showCustomPopup(context, 'Error',
                                  'This subscription is not allow Gem payment menthod.')
                              : _showCustomPopup(context, 'Lỗi',
                                  'Gói đăng ký này không có phương thức thanh toán bằng Gem.');
                        } else {
                          trans.locale == 'en'
                              ? _showCustomPopup(context, 'Error',
                                  'Not enough Gem for subscription.')
                              : _showCustomPopup(context, 'Lỗi',
                                  'Bạn không có đủ Gem để đăng ký.');
                        }
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
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: stroke),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                convertDuration(sub.durationInMonth, trans.locale) ,
                textAlign: TextAlign.center,
                style: min_cap.copyWith(color: theme.colorScheme.onSurface),
              ),
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
            ],
          ),
          const SizedBox(width: 36),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Emerald.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      child: Text(
                        '${sub.gemPrice} ',
                        style: h3.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  (sub.gemPrice != null && sub.price != null) ? (trans.or) : '',
                  style: min_cap.copyWith(color: text, height: 1),
                ),
                Text(
                  '${sub.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VND',
                  style: h3.copyWith(
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
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

  Future<UserSubscription?> makeSubExpire(UserSubscription usub) async {
    final userSubscription =
      await expiredSubscription(usub.id!);
      if (userSubscription != null) {
        widget.fetchAccount!();
        final account = await retrieveAccount();
        _loadUserSub();
        setState(() {
          _account = account;
        });
  }}

  String? checkExpire(UserSubscription usub) {
    DateTime now = DateTime.now();
    final trans = AppLocalizations.of(context)!;
    String? expireDateStr = usub.expireDate;
    String checkDateExpired = format.checkDateExpired(
        usub.createdAt.toString(), expireDateStr.toString(), trans);
    print(checkDateExpired);
    bool check = checkDateExpired.startsWith(RegExp(r'[0-9]'));
    if (check) {
      return checkDateExpired;
    }
    return null;
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
