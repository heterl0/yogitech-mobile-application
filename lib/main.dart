// main.dart
import 'dart:async';
import 'dart:io';
import 'package:YogiTech/views/no_internet_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:YogiTech/l10n/l10n.dart';
import 'package:YogiTech/models/notification.dart' as n;
import 'package:YogiTech/models/social.dart';
import 'package:YogiTech/notifi_services/notifi_service.dart';
import 'package:YogiTech/routing/app_routes.dart';
import 'package:YogiTech/services/account/account_service.dart';
import 'package:YogiTech/services/auth/auth_service.dart';
import 'package:YogiTech/services/dioInstance.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:YogiTech/views/_mainscreen.dart';
import 'package:YogiTech/views/auth/forgot_password_screen.dart';
import 'package:YogiTech/views/auth/login_screen.dart';
import 'package:YogiTech/views/auth/reset_password_screen.dart';
import 'package:YogiTech/views/auth/sign_up_screen.dart';
import 'package:YogiTech/views/auth/verify_email_screen.dart';
import 'package:YogiTech/views/blog/blog_screen.dart';
import 'package:YogiTech/views/event/activities_screen.dart';
import 'package:YogiTech/views/event/event_detail_screen.dart';
import 'package:YogiTech/views/exercise/exercise_detail_screen.dart';
import 'package:YogiTech/views/exercise/result_exercise_practice_screen.dart';
import 'package:YogiTech/views/home/home_screen.dart';
import 'package:YogiTech/views/home/payment_history_screen.dart';
import 'package:YogiTech/views/home/streak_screen.dart';
import 'package:YogiTech/views/home/subscription_screen.dart';
import 'package:YogiTech/views/meditate/meditate_screen.dart';
import 'package:YogiTech/views/meditate/perform_meditate_screen.dart';
import 'package:YogiTech/views/notifi/notification_detail_screen.dart';
import 'package:YogiTech/views/notifi/notifications_screen.dart';
import 'package:YogiTech/views/pre_launch_survey_screen.dart';
import 'package:YogiTech/views/profile/change_profile_screen.dart';
import 'package:YogiTech/views/profile/profile_screen.dart';
import 'package:YogiTech/views/settings/reminder_screen.dart';
import 'package:YogiTech/views/settings/settings_screen.dart';
import 'package:YogiTech/views/social/friend_profile.dart';
import 'services/download/download_service.dart';
import 'viewmodels/auth/auth_viewmodel.dart';
import 'viewmodels/blog/blog_detail_viewmodel.dart';
import 'viewmodels/profile/change_BMI_viewmodel.dart';
import 'views/inprogress/OTP_confirm_screen.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

// ============================================================================
// GLOBAL VARIABLES
// ============================================================================
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// ============================================================================
// APP INITIALIZATION
// ============================================================================
Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // setting timezone for local follow the local devices
  // tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

  await LocalNotificationService().init();
  HttpOverrides.global = MyHttpOverrides();
  FlutterNativeSplash.remove();
  await _loadEnv();
}

Future<void> _loadEnv() async {
  await dotenv.load(fileName: ".env");
}

Future<String?> _checkToken() async {
  try {
    final tokens = await getToken();
    final accessToken = tokens['access'];
    if (accessToken != null) {
      String timezoneLocation = await FlutterTimezone.getLocalTimezone();

      DioInstance.setAccessToken(accessToken, timezoneLocation);
      await getUser();
    }
    return accessToken;
  } catch (error) {
    return null;
  }
}

// Future<void> requestStoragePermission() async {
//   if (await Permission.storage.isGranted) {
//     print("🔹 Quyền storage đã được cấp!");
//   } else {
//     final status = await Permission.storage.request();
//     if (status.isGranted) {
//       print("🔹 Quyền storage được cấp!");
//     } else if (status.isDenied) {
//       print("❌ Quyền storage bị từ chối!");
//       // Hiển thị dialog thông báo nếu cần
//     } else if (status.isPermanentlyDenied) {
//       print("❌ Quyền storage bị từ chối vĩnh viễn!");
//       await openAppSettings(); // Mở cài đặt để người dùng cấp quyền
//     }
//   }
// }

// ============================================================================
// WORKMANAGER CONFIGURATION
// ============================================================================
Future<void> _setupWorkManager() async {
  final prefs = await SharedPreferences.getInstance();
  final bool isNotificationsOn = prefs.getBool('friendActivitiesOn') ?? false;

  if (isNotificationsOn) {
    await Workmanager().initialize(callbackDispatcher);
    Workmanager().registerOneOffTask(
      "fetchAndNotify",
      "fetchAndNotify",
      initialDelay: const Duration(seconds: 5),
    );
  } else {
    Workmanager().cancelAll();
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isNotificationsOn = prefs.getBool('friendActivitiesOn') ?? false;
    if (!isNotificationsOn) return Future.value(false);

    final now = DateTime.now().subtract(const Duration(minutes: 15));
    await _loadEnv();
    final accessToken = await prefs.getString('accessToken');
    final url = formatApiUrl('/api/v1/notification/');
    final dio = Dio()..options.headers['Authorization'] = 'Bearer $accessToken';

    try {
      final response = await dio.get(url);
      final notifications = (response.data as List)
          .map((e) => n.Notification.fromMap(e))
          .where(
              (notification) => DateTime.parse(notification.time).isAfter(now))
          .toList();

      if (notifications.isNotEmpty) {
        _showNotifications(notifications);
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

// ============================================================================
// NOTIFICATION HANDLING
// ============================================================================
Future<void> _showNotifications(List<dynamic> notifications) async {
  final now = DateTime.now();

  for (var notification in notifications) {
    final notificationTime = DateTime.parse(notification.time);
    final scheduledTime = notificationTime.isAfter(now)
        ? notificationTime
        : now.add(const Duration(seconds: 5));

    await LocalNotificationService.showActivitiesNotification(
      id: notification.id + 10,
      title: notification.title,
      body: notification.body,
      scheduledTime: scheduledTime,
      payload: 'friend_notification_${notification.id}',
    );
  }
}

// ============================================================================
// HTTP OVERRIDES
// ============================================================================
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// ============================================================================
// MAIN APP
// ============================================================================
void main() async {
  await _initializeApp();
  // await requestStoragePermission();
  final accessToken = await _checkToken();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await _setupWorkManager();

  // await DownloadService.preloadAssets();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => BlogDetailViewModel()),
        ChangeNotifierProvider(create: (_) => ChangeBMIViewModel()),
      ],
      child: MyApp(access: accessToken),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String? access;
  const MyApp({super.key, this.access});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ==========================================================================
  // STATE VARIABLES
  // ==========================================================================
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('vi');
  bool _isLoading = true;
  final SocialProfile _profile = SocialProfile(
    user_id: 1,
    username: 'username',
    first_name: 'first_name',
    last_name: 'last_name',
    avatar: 'https://via.placeholder.com/150',
    exp: 999,
    level: 1,
    streak: 1,
  );

  // ==========================================================================
  // LIFECYCLE METHODS
  // ==========================================================================
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // ==========================================================================
  // SETTINGS MANAGEMENT
  // ==========================================================================
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = prefs.getBool('isDarkMode') ?? true;

    if (isDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: elevationDark,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: elevationLight,
        ),
      );
    }
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _locale = Locale(prefs.getString('locale') ?? 'vn');
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    await prefs.setString('locale', _locale.languageCode);
  }

  void _toggleTheme(bool isDarkMode) {
    if (isDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: elevationDark,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: elevationLight,
        ),
      );
    }
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _saveSettings();
    });
  }

  void _changeLanguage(bool isVietnamese) {
    setState(() {
      _locale = isVietnamese ? const Locale('vi') : const Locale('en');
      _saveSettings();
    });
  }

  // ==========================================================================
  // UI BUILD
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          // AppRoutes.noInternet,
          widget.access != null ? AppRoutes.firstScreen : AppRoutes.login,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      supportedLocales: L10n.all,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: _buildRoutes(),
    );
  }

  // ==========================================================================
  // ROUTING CONFIGURATION
  // ==========================================================================
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.firstScreen: (_) => MainScreen(
            isVietnamese: _locale == const Locale('vi'),
            isDarkMode: _themeMode == ThemeMode.dark,
            onThemeChanged: _toggleTheme,
            locale: _locale,
            onLanguageChanged: _changeLanguage,
          ),
      AppRoutes.homepage: (_) => HomePage(),
      AppRoutes.login: (_) => LoginPage(),
      AppRoutes.signup: (_) => SignUp(),
      AppRoutes.verifyEmail: (_) => VerifyEmail(),
      AppRoutes.forgotpassword: (_) => ForgotPasswordScreen(),
      AppRoutes.OtpConfirm: (_) => OTP_Page(),
      AppRoutes.ResetPassword: (_) => ResetPasswordPage(),
      AppRoutes.preLaunchSurvey: (_) => PrelaunchSurveyPage(),
      AppRoutes.meditate: (_) => Meditate(),
      AppRoutes.performMeditate: (_) => PerformMeditate(),
      AppRoutes.streak: (_) => Streak(),
      AppRoutes.exercisedetail: (_) => ExerciseDetail(),
      AppRoutes.result: (_) => Result(),
      AppRoutes.subscription: (_) => SubscriptionPage(),
      AppRoutes.Profile: (_) => ProfilePage(
            isDarkMode: _themeMode == ThemeMode.dark,
            onThemeChanged: _toggleTheme,
            locale: _locale,
            onLanguageChanged: _changeLanguage,
            isVietnamese: _locale == const Locale('vi'),
          ),
      AppRoutes.activities: (_) => Activities(),
      AppRoutes.eventDetail: (_) => EventDetail(event: null),
      AppRoutes.blog: (_) => Blog(),
      AppRoutes.reminder: (_) => ReminderPage(),
      AppRoutes.notifications: (_) => NotificationsPage(),
      AppRoutes.notificationDetail: (_) => NotificationDetail(),
      AppRoutes.friendProfile: (_) => FriendProfile(profile: _profile),
      AppRoutes.settings: (_) => SettingsPage(
            isVietnamese: _locale == const Locale('vi'),
            isDarkMode: _themeMode == ThemeMode.dark,
            onThemeChanged: _toggleTheme,
            locale: _locale,
            onLanguageChanged: _changeLanguage,
          ),
      AppRoutes.paymentHistory: (_) => PaymentHistory(),
      AppRoutes.changeProfile: (_) => ChangeProfilePage(),
      AppRoutes.noInternet: (_) => const NoInternetScreen(),
    };
  }
}
