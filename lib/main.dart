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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, String?> loginInfo = await getLoginInfo();
  String? savedEmail = loginInfo['email'];
  String? savedPassword = loginInfo['password'];

  bool isLoggedIn = savedEmail != null && savedPassword != null;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    initialRoute: isLoggedIn ? AppRoutes.Meditate : AppRoutes.Meditate,
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
      AppRoutes.Meditate: (context) => Meditate(),
      AppRoutes.PerformMeditate: (context) => PerformMeditate(),
    },
  ));
}

class HomePage extends StatefulWidget {
  final String? savedEmail;
  final String? savedPassword;

  HomePage({required this.savedEmail, required this.savedPassword});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    print(
        'savedEmail: ${widget.savedEmail}'); // In giá trị của savedEmail ra console
    print(
        'savedPassword: ${widget.savedPassword}'); // In giá trị của savedPassword ra console
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Homepage'),
          backgroundColor: Colors.blueGrey),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.savedEmail != null && widget.savedPassword != null)
              Column(
                children: [
                  Text(
                    'Logged in as:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: ${widget.savedEmail}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Password: ${widget.savedPassword}',
                    style: TextStyle(fontSize: 14),
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
            if (widget.savedEmail != null && widget.savedPassword != null)
              Column(
                children: [
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Confirm OTP'),
                    onPressed: () async {
                      await clearLoginInfo(); // Xóa thông tin đăng nhập
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.OtpConfirm);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      // bottomNavigationBar: ,
    );
  }
}
