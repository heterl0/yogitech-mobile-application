import 'package:flutter/material.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';

class PaymentHistory extends StatefulWidget {
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(24.0),
      //       bottomRight: Radius.circular(24.0),
      //     ),
      //     child: AppBar(
      //       automaticallyImplyLeading: false,
      //       backgroundColor: theme.colorScheme.onSecondary,
      //       bottom: PreferredSize(
      //         preferredSize: Size.fromHeight(0),
      //         child: Padding(
      //           padding: const EdgeInsets.only(
      //             bottom: 12.0,
      //             right: 20.0,
      //             left: 20.0,
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               IconButton(
      //                 icon: Icon(Icons.arrow_back, color: Colors.white),
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //               ),
      //               Spacer(),
      //               Text('Payment History', style: h2.copyWith(color: active)),
      //               Spacer(
      //                 flex: 2,
      //               ), // Adjust the flex value to center the title properly
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      appBar: CustomAppBar(
        style: widthStyle.Large,
        title: "Payment History",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildPaymentRow(
              context,
              image: 'assets/images/Sun.png',
              title: 'Once a Year',
              date: '01/01/2023',
              amount: '1.000.000đ',
              isGem: false,
            ),
            SizedBox(height: 16),
            buildPaymentRow(
              context,
              image: 'assets/images/MoonPhase.png',
              title: 'Once a Year',
              date: '01/01/2023',
              amount: '999',
              isGem: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentRow(
    BuildContext context, {
    required String image,
    required String title,
    required String date,
    required String amount,
    required bool isGem,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.background,
        padding: EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          Image.asset(image, height: 48, width: 48), // Use Image.asset
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
                Text(
                  date,
                  style:
                      min_cap.copyWith(color: theme.colorScheme.onBackground),
                ),
              ],
            ),
          ),
          if (isGem) ...[
            Row(
              children: [
                Image.asset('assets/images/Emerald.png', height: 24, width: 24),
                SizedBox(width: 4),
                Text(
                  amount,
                  style: h3.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ],
            )
          ] else ...[
            Text(
              amount,
              style: h3.copyWith(color: primary),
            ),
          ],
        ],
      ),
    );
  }
}

String formatCurrency(int amount) {
  return amount.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]}.',
      );
}
