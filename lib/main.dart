import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/pages/forgot_password.dart';
import 'package:yogi_application/src/pages/pre_launch_survey_page.dart';
import 'package:yogi_application/src/pages/meditate.dart';
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/sign_up_page.dart';
import 'package:yogi_application/src/pages/OTP_confirm_page.dart';
import 'package:yogi_application/src/pages/reset_password_page.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:dio/dio.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:yogi_application/l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 10));
  // FlutterNativeSplash.remove();

  Map<String, String?> loginInfo = await getLoginInfo();
  String? savedEmail = loginInfo['email'];
  String? savedPassword = loginInfo['password'];

  bool isLoggedIn = savedEmail != null && savedPassword != null;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    initialRoute: isLoggedIn ? AppRoutes.homepage : AppRoutes.homepage,
    // initialRoute: AppRoutes.OtpConfirm,
    routes: {
      AppRoutes.home: (context) =>
          HomePage(savedEmail: savedEmail, savedPassword: savedPassword),
      AppRoutes.login: (context) => LoginPage(),
      AppRoutes.signup: (context) => SignUp(),
      AppRoutes.forgotpassword: (context) => ForgotPasswordPage(),
      AppRoutes.OtpConfirm: (context) => OTP_Page(),
      AppRoutes.ResetPassword: (context) => ResetPasswordPage(),
      AppRoutes.preLaunchSurvey: (context) => PrelaunchSurveyPage(),
      AppRoutes.homepage: (context) =>
          HomePage(savedEmail: savedEmail, savedPassword: savedPassword),
      AppRoutes.Meditate: (context) => Meditate(),
      AppRoutes.PerformMeditate: (context) => PerformMeditate(),
    },
  ));
}
