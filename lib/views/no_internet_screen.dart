import 'package:ZenAiYoga/shared/styles.dart';
import 'package:ZenAiYoga/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../routing/app_routes.dart';
import '../services/network/network_service.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildNoInternetContent(context),
      ),
    );
  }

  Widget _buildNoInternetContent(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/signal_wifi_bad.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            trans.failedConnectTitle,
            textAlign: TextAlign.center,
            style: h2.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            trans.failedConnectText,
            textAlign: TextAlign.center,
            style: bd_text.copyWith(color: theme.colorScheme.onPrimary),
          ),
          const SizedBox(height: 48),
          CustomButton(
            title: trans.tryConnectAgain,
            style: ButtonStyleType.Primary,
            onPressed: () async {
              final hasInternet = await NetworkService.hasInternetConnection();
              if (hasInternet) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(trans.failedConnectText)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
