import 'dart:async';

import 'package:ZenAiYoga/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../routing/app_routes.dart';
import '../services/network/network_service.dart';
import '../widgets/box_button.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  StreamSubscription? _subscription;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      final hasInternet = await NetworkService.hasInternetConnection();
      if (hasInternet && !_isChecking) {
        _checkInternetAndRedirect();
      }
    });
  }

  Future<void> _checkInternetAndRedirect() async {
    setState(() => _isChecking = true);

    final hasInternet = await NetworkService.hasInternetConnection();
    await Future.delayed(
        const Duration(milliseconds: 300)); // Delay nhẹ để thấy loading

    if (!mounted) return;

    if (hasInternet) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      setState(
          () => _isChecking = false); // Trả về lại giao diện nếu vẫn mất mạng
    }
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
        child: _isChecking
            ? const CircularProgressIndicator()
            : _buildNoInternetContent(context),
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
              decoration: const BoxDecoration(
                image: DecorationImage(
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
            onPressed: _isChecking ? null : _checkInternetAndRedirect,
          ),
        ],
      ),
    );
  }
}
