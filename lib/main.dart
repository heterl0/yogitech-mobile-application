import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/sign_up_page.dart';
import 'package:yogi_application/src/shared/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, String?> loginInfo = await getLoginInfo();
  String? savedEmail = loginInfo['email'];
  String? savedPassword = loginInfo['password'];

  bool isLoggedIn = savedEmail != null && savedPassword != null;

  runApp(MyApp(
      isLoggedIn: isLoggedIn,
      savedEmail: savedEmail,
      savedPassword: savedPassword));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? savedEmail;
  final String? savedPassword;

  MyApp({required this.isLoggedIn, this.savedEmail, this.savedPassword});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      routes: {
        AppRoutes.home: (context) =>
            HomePage(savedEmail: savedEmail, savedPassword: savedPassword),
        AppRoutes.login: (context) => LoginPage(),
        AppRoutes.signup: (context) => SignUp()
      },
      theme: lightTheme, // Áp dụng Light Theme
      darkTheme: darkTheme, // Áp dụng Dark Theme
      themeMode: ThemeMode
          .dark, // Sử dụng ThemeMode.system để tự động chuyển đổi giữa Dark và Light theo hệ thống
    );
  }
}

class HomePage extends StatelessWidget {
  final String? savedEmail;
  final String? savedPassword;

  HomePage({required this.savedEmail, required this.savedPassword}) {
    print('savedEmail: $savedEmail'); // In giá trị của savedEmail ra console
    print(
        'savedPassword: $savedPassword'); // In giá trị của savedPassword ra console
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Homepage'),
        backgroundColor: theme.primaryColor, // Sử dụng màu chính từ theme
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (savedEmail != null && savedPassword != null)
              Column(
                children: [
                  Text(
                    'Logged in as:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: $savedEmail',
                    style: theme
                        .textTheme.bodyText1, // Sử dụng text style từ theme
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Password: $savedPassword',
                    style: theme
                        .textTheme.bodyText1, // Sử dụng text style từ theme
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Log out'),
                    onPressed: () async {
                      await clearLoginInfo(); // Xóa thông tin đăng nhập
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
