import 'dart:async'; // 👈 Thêm dòng này

import 'package:ZenAiYoga/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // 👈 Thêm dòng này

import '../routing/app_routes.dart';
import '../services/network/network_service.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      final hasInternet = await NetworkService.hasInternetConnection();
      if (hasInternet) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

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
        ],
      ),
    );
  }
}
