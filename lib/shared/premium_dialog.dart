// premium_dialog.dart
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/views/home/subscription.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

void showPremiumDialog(
    BuildContext context, Account account, VoidCallback? fetchAccount) {
  final theme = Theme.of(context);
  final trans = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        elevation: appElevation,
        backgroundColor: theme.colorScheme.onSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                trans.premiumFeature, // "Premium Required"
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                trans
                    .needPremium, // "This pose is only available for premium users."
                textAlign: TextAlign.center,
                style: bd_text.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: trans.close, // "Close"
                      style: ButtonStyleType
                          .Tertiary, // Hoặc kiểu button tương ứng
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomButton(
                      title: trans.subscription, // "Upgrade Now"
                      onPressed: () {
                        Navigator.of(context).pop();
                        pushWithoutNavBar(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubscriptionPage(
                                    account: account,
                                    fetchAccount: fetchAccount)));
                      },
                      style: ButtonStyleType.Primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
