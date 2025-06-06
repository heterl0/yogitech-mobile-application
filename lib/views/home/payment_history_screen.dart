import 'package:ZenAiYoga/models/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:ZenAiYoga/custombar/appbar.dart';
import 'package:ZenAiYoga/shared/styles.dart';
import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class PaymentHistory extends StatefulWidget {
  final List<dynamic>? userSubs;
  final List<dynamic>? subs;

  const PaymentHistory({super.key, this.userSubs, this.subs});

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<dynamic>? _userSubs;
  List<dynamic>? _subs;

  @override
  void initState() {
    super.initState();
    _userSubs = widget.userSubs;
    _subs = widget.subs;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        style: WidthStyle.large,
        title: trans.paymentHistory,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _userSubs!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _userSubs!.length,
                itemBuilder: (context, index) {
                  int reverseIndex = _userSubs!.length - 1 - index;
                  return buildPaymentRow(
                      context, _userSubs![reverseIndex], trans);
                },
              )
            : Center(
                child: Text(
                  trans.noHistory,
                  style: bd_text.copyWith(color: text),
                ),
              ),
      ),
    );
  }

  Widget buildPaymentRow(
      BuildContext context, UserSubscription usub, AppLocalizations trans) {
    Subscription sub = _subs!.firstWhere(
      (sub) => sub.id == usub.subscriptionId,
      orElse: () => null,
    );

    final local = Localizations.localeOf(context);
    String startDay = DateFormat.yMMMd(local.languageCode)
        .add_Hm()
        .format(DateTime.parse('${usub.createdAt}').toUtc().toLocal());
    String endDay = DateFormat.yMMMd(local.languageCode)
        .add_Hm()
        .format(DateTime.parse('${usub.expireDate}').toUtc().toLocal());

    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        padding: EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
              sub.durationInMonth < 1
                  ? 'assets/images/Universe.png'
                  : (sub.durationInMonth >= 12
                      ? 'assets/images/Sun.png'
                      : 'assets/images/MoonPhase.png'),
              height: 48,
              width: 48), // Use Image.asset
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  convertDuration(sub.durationInMonth, trans.locale),
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                Text(
                  startDay,
                  style: min_cap.copyWith(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
          if (usub.subscriptionType == 1) ...[
            Row(
              children: [
                Image.asset('assets/images/Emerald.png', height: 24, width: 24),
                SizedBox(width: 4),
                Text(
                  '${sub.gemPrice}',
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ],
            )
          ] else ...[
            Text(
              '${formatCurrency(sub.price)}',
              style: h3.copyWith(color: primary),
            ),
          ],
        ],
      ),
    );
  }
}

String formatCurrency(double amount) {
  return '${amount.toInt().toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')} VND';
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
