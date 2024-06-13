import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:yogi_application/src/services/api_service.dart';
import 'package:yogi_application/src/pages/activities.dart';
import 'package:yogi_application/src/pages/blog.dart';
import 'package:yogi_application/src/pages/blog_detail.dart';
import 'package:yogi_application/src/pages/event_detail.dart';
import 'package:yogi_application/src/pages/change_profile.dart';
import 'package:yogi_application/src/pages/exercise_detail.dart';
import 'package:yogi_application/src/pages/forgot_password.dart';
import 'package:yogi_application/src/pages/friend_profile.dart';
import 'package:yogi_application/src/pages/notifications.dart';
import 'package:yogi_application/src/pages/payment_history.dart';
import 'package:yogi_application/src/pages/pre_launch_survey_page.dart';
import 'package:yogi_application/src/pages/meditate.dart';
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'package:yogi_application/src/pages/reminder.dart';
import 'package:yogi_application/src/pages/result.dart';
import 'package:yogi_application/src/pages/streak.dart';
import 'package:yogi_application/src/pages/subscription.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/sign_up_page.dart';
import 'package:yogi_application/src/pages/OTP_confirm_page.dart';
import 'package:yogi_application/src/pages/reset_password_page.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:yogi_application/src/pages/profile.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/pages/settings.dart';
import 'dart:io';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // Delay cho màn hình splash (chỉ dùng để demo, điều chỉnh tùy ý)
  await Future.delayed(const Duration(seconds: 10));
  FlutterNativeSplash.remove();
  await checkToken();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

Future<void> checkToken() async {
  // Lấy token từ SharedPreferences

  final tokens = await getToken();

  final accessToken = tokens['access'];
  final refreshToken = tokens['refresh'];
  if (accessToken != null) {
    runApp(MyApp());
  } else {
    runApp(const MyApp());
  }
}

Future<void> loadEnv() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");
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
          ? AppRoutes.homepage
          : AppRoutes.login,
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
        AppRoutes.exercisedetail: (context) => ExerciseDetail(),
        AppRoutes.result: (context) => Result(),
        AppRoutes.subscription: (context) => Subscription(),
        AppRoutes.Profile: (context) => ProfilePage(
            isDarkMode: _themeMode == ThemeMode.dark,
            onThemeChanged: _toggleTheme),
        AppRoutes.activities: (context) => Activities(),
        AppRoutes.eventDetail: (context) => EventDetail(
              title: 'Event Title',
              caption: 'Event Caption',
              remainingDays: 'Event Subtitle',
            ),
        AppRoutes.blog: (context) => Blog(),
        AppRoutes.blogDetail: (context) => BlogDetail(
              title: 'Event Title',
              caption: 'Event Caption',
              subtitle: 'Event Subtitle',
            ),
        AppRoutes.reminder: (context) => ReminderPage(),
        AppRoutes.notifications: (context) => NotificationsPage(),
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
