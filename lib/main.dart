import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/pages/forgot_password.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:yogi_application/src/pages/pre_launch_survey_page.dart';
import 'package:yogi_application/src/pages/meditate.dart';
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'package:yogi_application/src/pages/streak.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/sign_up_page.dart';
import 'package:yogi_application/src/pages/OTP_confirm_page.dart';
import 'package:yogi_application/src/pages/reset_password_page.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 5));
  FlutterNativeSplash.remove();

  Map<String, String?> loginInfo = await getLoginInfo();
  String? savedEmail = loginInfo['email'];
  String? savedPassword = loginInfo['password'];

  bool isLoggedIn = savedEmail != null && savedPassword != null;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    initialRoute:
        isLoggedIn ? AppRoutes.exercisedetail : AppRoutes.exercisedetail,
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
      AppRoutes.meditate: (context) => Meditate(),
      AppRoutes.performMeditate: (context) => PerformMeditate(),
      AppRoutes.streak: (context) => Streak(),
      AppRoutes.exercisedetail: (context) => ExerciseDetail(),
    },
  ));
}
