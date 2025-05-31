// premium_dialog.dart
import 'package:ZenAiYoga/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:ZenAiYoga/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showDevelopmentDialog(BuildContext context) {
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
                trans.developmentFeature, // "Feature in Development"
                style: h3.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                trans
                    .featureInDevelopment, // "This feature is currently in development."
                textAlign: TextAlign.center,
                style: bd_text.copyWith(color: theme.colorScheme.onPrimary),
              ),
              const SizedBox(height: 12),
              CustomButton(
                title: trans.close, // "Close"
                style: ButtonStyleType.Tertiary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
