import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

import 'viewmodels/auth/auth_viewmodel.dart';
import 'viewmodels/blog/blog_detail_viewmodel.dart';
import 'viewmodels/profile/change_BMI_viewmodel.dart';
import 'views/inprogress/OTP_confirm_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  // Đảm bảo WidgetsFlutterBinding đã được khởi tạo
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  tz.initializeTimeZones();
  tz.setLocalLocation(
      tz.getLocation('Asia/Ho_Chi_Minh')); // Đặt múi giờ Việt Nam
  // Khởi tạo các dịch vụ hoặc các thành phần cần thiết khác
  await LocalNotificationService().init();
  HttpOverrides.global = MyHttpOverrides();

  // Loại bỏ splash screen ngay lập tức
  FlutterNativeSplash.remove();
  // Tải các biến môi trường
  await loadEnv();
  // Kiểm tra và lấy token
  final accessToken = await checkToken();

  // Đặt chế độ xoay màn hình
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isNotificationsOn = prefs.getBool('friendActivitiesOn') ?? false;
  if (isNotificationsOn) {
    await Workmanager().initialize(callbackDispatcher);
    // Workmanager().registerPeriodicTask(
    //   "15_min_task",
    //   "fetchAndNotify",
    //   frequency: const Duration(minutes: 15),
    // );
    Workmanager().registerOneOffTask(
      "fetchAndNotify",
      "fetchAndNotify",
      initialDelay: Duration(seconds: 5),
    );
    print("Task registered");
  } else {
    Workmanager().cancelAll();
  }
  // Chạy ứng dụng với token nếu có
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(),
        ),
        ChangeNotifierProvider(create: (context) => BlogDetailViewModel()),
        ChangeNotifierProvider(create: (context) => ChangeBMIViewModel()),
        // ChangeNotifierProvider(create: (context) => ChangeProfileViewModel()),
      ],
      child: MyApp(access: accessToken),
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Đặt múi giờ Việt Nam
    // await LocalNotificationService().init();
    // Fetch notifications from your serve
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isNotificationsOn = prefs.getBool('friendActivitiesOn') ?? false;
    if (!isNotificationsOn) {
      return Future.value(false);
    }
    DateTime now = DateTime.now().subtract(Duration(minutes: 15));
    await loadEnv();

    final accessToken = await prefs.getString('accessToken');

    // final url = dotenv.get("API_BASE_URL") + '/api/v1/notification/';
    final url = formatApiUrl('/api/v1/notification/');
    final _dio = Dio();
    _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    final Response response = await _dio.get(url);
    List<dynamic> notifications = response.data
        .map((e) => n.Notification.fromMap(e))
        .toList()
        .where((notification) {
      DateTime notificationTime = DateTime.parse(notification.time);
      return notificationTime.isAfter(now);
    }).toList();
    if (notifications.isNotEmpty) {
      // Parse the response and schedule a notification
      showNotification(notifications);
    }
    print(notifications);
    print('Task was executed');
    return Future.value(true);
  });
}

void showNotification(List<dynamic> notifications) async {
  final now = DateTime.now();
  print('Showing notifications');
  print(notifications.length);

  for (var notification in notifications) {
    print(notification);
    final notificationTime = DateTime.parse(notification.time);
    if (notificationTime.isAfter(now)) {
      await LocalNotificationService.showActivitiesNotification(
        id: notification.id + 10,
        title: notification.title,
        body: notification.body,
        scheduledTime: notificationTime,
        payload: 'friend_notification_${notification.id}',
      );
    } else {
      await LocalNotificationService.showActivitiesNotification(
        id: notification.id + 10,
        title: notification.title,
        body: notification.body,
        scheduledTime: now.add(Duration(seconds: 5)),
        payload: 'friend_notification_${notification.id}',
      );
    }
  }
}

Future<String?> checkToken() async {
  try {
    final tokens = await getToken();
    final accessToken = tokens['access'];
    if (accessToken != null) {
      DioInstance.setAccessToken(accessToken);
      await getUser();
    }
    return accessToken;
  } catch (error) {
    // Handle error, e.g., log the error or show an error message.
    print("Error fetching token: $error");
    // You might want to redirect to a login screen or handle the error differently.
  }
  return null;
}

Future<void> loadEnv() async {
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

  const MyApp({super.key, this.access});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');
  bool _isLoading = true; // Biến để kiểm soát việc load settings
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Hàm tải cài đặt
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = prefs.getBool('isDarkMode') ?? false
          ? ThemeMode.dark
          : ThemeMode.light;
      final localeCode = prefs.getString('locale') ?? 'en'; // Lấy language code
      _locale = Locale(localeCode);
      _isLoading = false;
    });
  }

  // Hàm lưu cài đặt
  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    await prefs.setString('locale', _locale.languageCode); // Lưu language code
  }

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _saveSettings(); // Save settings after changing theme
    });
  }

  void _changeLanguage(bool isVietnamese) {
    setState(() {
      _locale = isVietnamese ? Locale('vi') : Locale('en');
      _saveSettings();
    });
  }

  final SocialProfile profile = SocialProfile(
    user_id: 1,
    username: 'username',
    first_name: 'first_name',
    last_name: 'last_name',
    avatar: 'https://via.placeholder.com/150',
    exp: 999,
    level: 1,
    streak: 1,
  );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
          child:
              CircularProgressIndicator()); // Hiển thị màn hình loading trước
    }
    FlutterNativeSplash.remove();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute:
            widget.access != null ? AppRoutes.firstScreen : AppRoutes.login,
        // onGenerateRoute: _generateRoute,
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
        routes: {
          AppRoutes.firstScreen: (context) => MainScreen(
                isVietnamese: _locale == const Locale('vi'),
                isDarkMode: _themeMode == ThemeMode.dark,
                onThemeChanged: _toggleTheme,
                locale: _locale,
                onLanguageChanged: _changeLanguage,
              ),
          AppRoutes.homepage: (context) => HomePage(),
          AppRoutes.login: (context) => LoginPage(),
          AppRoutes.signup: (context) => SignUp(),
          AppRoutes.verifyEmail: (context) => VerifyEmail(),
          AppRoutes.forgotpassword: (context) => ForgotPasswordScreen(),
          AppRoutes.OtpConfirm: (context) => OTP_Page(),
          AppRoutes.ResetPassword: (context) => ResetPasswordPage(),
          AppRoutes.preLaunchSurvey: (context) => PrelaunchSurveyPage(),
          AppRoutes.meditate: (context) => Meditate(),
          AppRoutes.performMeditate: (context) => PerformMeditate(),
          AppRoutes.streak: (context) => Streak(),
          AppRoutes.exercisedetail: (context) => ExerciseDetail(),
          AppRoutes.result: (context) => Result(),
          AppRoutes.subscription: (context) => SubscriptionPage(),
          AppRoutes.Profile: (context) => ProfilePage(
                isDarkMode: _themeMode == ThemeMode.dark,
                onThemeChanged: _toggleTheme,
                locale: _locale,
                onLanguageChanged: _changeLanguage,
                isVietnamese: _locale == Locale('vi'),
              ),
          AppRoutes.activities: (context) => Activities(),
          AppRoutes.eventDetail: (context) => EventDetail(
                event: null,
              ),
          AppRoutes.blog: (context) => Blog(),
          AppRoutes.reminder: (context) => ReminderPage(),
          AppRoutes.notifications: (context) => NotificationsPage(),
          AppRoutes.notificationDetail: (context) => NotificationDetail(),
          AppRoutes.friendProfile: (context) => FriendProfile(
              // Sửa lại tên class
              profile: profile),
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
