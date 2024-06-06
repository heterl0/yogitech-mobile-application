import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/pages/activities.dart';
import 'package:yogi_application/src/pages/event_detail.dart';
import 'package:yogi_application/src/pages/change_profile.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/pages/forgot_password.dart';
import 'package:yogi_application/src/pages/friend_profile.dart';
import 'package:yogi_application/src/pages/payment_history.dart';
import 'package:yogi_application/src/pages/pre_launch_survey_page.dart';
import 'package:yogi_application/src/pages/meditate.dart';
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'package:yogi_application/src/pages/result.dart';
import 'package:yogi_application/src/pages/streak.dart';
import 'package:yogi_application/src/pages/subscription.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/sign_up_page.dart';
import 'package:yogi_application/src/pages/OTP_confirm_page.dart';
import 'package:yogi_application/src/pages/reset_password_page.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:yogi_application/src/pages/profile.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:yogi_application/src/pages/settings.dart'; // Import SettingsPage
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Future.delayed(const Duration(seconds: 10));
  FlutterNativeSplash.remove();

  Map<String, String?> loginInfo = await getLoginInfo();
  String? savedEmail = loginInfo['email'];
  String? savedPassword = loginInfo['password'];

  bool isLoggedIn = savedEmail != null && savedPassword != null;

  runApp(MyApp(savedEmail: savedEmail, savedPassword: savedPassword));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  final String? savedEmail;
  final String? savedPassword;

  const MyApp({Key? key, this.savedEmail, this.savedPassword})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark; // Initialize with dark theme

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.savedEmail != null && widget.savedPassword != null
          ? AppRoutes.friendProfile
          : AppRoutes.friendProfile,
      routes: {
        AppRoutes.homepage: (context) => HomePage(
            savedEmail: widget.savedEmail, savedPassword: widget.savedPassword),
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.signup: (context) => SignUp(),
        AppRoutes.forgotpassword: (context) => ForgotPasswordPage(),
        AppRoutes.OtpConfirm: (context) => OTP_Page(),
        AppRoutes.ResetPassword: (context) => ResetPasswordPage(),
        AppRoutes.preLaunchSurvey: (context) => PrelaunchSurveyPage(),
        AppRoutes.meditate: (context) => Meditate(),
        AppRoutes.performMeditate: (context) => performMeditate(),
        AppRoutes.streak: (context) => Streak(),
        AppRoutes.exercisedetail: (context) => exerciseDetail(),
        AppRoutes.result: (context) => Result(),
        AppRoutes.subscription: (context) => Subscription(),
        AppRoutes.Profile: (context) => ProfilePage(
            isDarkMode: _themeMode == ThemeMode.dark,
            onThemeChanged: _toggleTheme),
        AppRoutes.activities: (context) => activities(),
        AppRoutes.eventdetail: (context) => eventDetail(
              title: 'Event Title',
              caption: 'Event Caption',
              subtitle: 'Event Subtitle',
            ),
        AppRoutes.friendProfile: (context) => FriendProfile(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.settings) {
          return MaterialPageRoute(
            builder: (context) => SettingsPage(
              isDarkMode: _themeMode == ThemeMode.dark,
              onThemeChanged: _toggleTheme,
            ),
          );
        } else if (settings.name == AppRoutes.paymentHistory) {
          return MaterialPageRoute(builder: (context) => PaymentHistory());
        } else if (settings.name == AppRoutes.changeProfile) {
          return MaterialPageRoute(builder: (context) => ChangeProfilePage());
        }
        return MaterialPageRoute(
            builder: (context) => HomePage(
                savedEmail: widget.savedEmail,
                savedPassword: widget.savedPassword));
      },
      theme: lightTheme, // Apply the light theme
      darkTheme: darkTheme, // Apply the dark theme
      themeMode: _themeMode, // Use current theme mode
    );
  }
}
