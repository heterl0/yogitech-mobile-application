import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/api/dioInstance.dart';
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
import 'package:yogi_application/src/pages/perform_meditate.dart';
import 'package:yogi_application/src/pages/pre_launch_survey_page.dart';
import 'package:yogi_application/src/pages/meditate.dart';
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
import 'package:yogi_application/src/pages/settings.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'dart:io';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  FlutterNativeSplash.remove(); // Remove splash screen immediately
  await loadEnv();
  final accessToken = await checkToken();
  print(accessToken);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(accessToken != null
      ? MyApp(access: accessToken)
      : MyApp()); // Conditional app start
}

Future<String?> checkToken() async {
  try {
    final tokens = await getToken();
    final accessToken = tokens['access'];
    DioInstance.setAccessToken(accessToken ?? "");
    return accessToken;
  } catch (error) {
    // Handle error, e.g., log the error or show an error message.
    print("Error fetching token: $error");
    // You might want to redirect to a login screen or handle the error differently.
  }
  return null;
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
  final String? access;

  const MyApp({Key? key, this.access}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('vi');

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(bool isVietnamese) {
    setState(() {
      _locale = isVietnamese ? Locale('vi') : Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
        // home: SplashScreen.navigate(
        //   name: 'assets/native_splash/logo.riv',
        //   next: (context) => MainScreen(
        //     isVietnamese: _locale == Locale('vi'),
        //     savedEmail: widget.savedEmail,
        //     savedPassword: widget.savedPassword,
        //     isDarkMode: _themeMode == ThemeMode.dark,
        //     onThemeChanged: _toggleTheme,
        //     locale: _locale,
        //     onLanguageChanged: _changeLanguage,
        //   ),
        //   until: () => Future.delayed(const Duration(seconds: 1)),
        //   startAnimation: '1',
        //   endAnimation: '1',
        //   backgroundColor: active,
        //   fit: BoxFit.fill,
        // ),
        debugShowCheckedModeBanner: false,
        initialRoute:
            widget.access != null ? AppRoutes.homepage : AppRoutes.login,
        routes: {
          AppRoutes.homepage: (context) => HomePage(),
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
                onThemeChanged: _toggleTheme,
                locale: _locale,
                onLanguageChanged: _changeLanguage,
                isVietnamese: _locale == Locale('vi'),
              ),
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
        });
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (context) => SettingsPage(
            isVietnamese: _locale == Locale('vi'),
            isDarkMode: _themeMode == ThemeMode.dark,
            onThemeChanged: _toggleTheme,
            locale: _locale,
            onLanguageChanged: _changeLanguage,
          ),
        );
      case AppRoutes.paymentHistory:
        return MaterialPageRoute(builder: (context) => PaymentHistory());
      case AppRoutes.changeProfile:
        return MaterialPageRoute(builder: (context) => ChangeProfilePage());
      default:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
    }
  }
}
