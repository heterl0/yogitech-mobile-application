import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, String?> loginInfo = await getLoginInfo();
  String? savedEmail = loginInfo['email'];
  String? savedPassword = loginInfo['password'];

  bool isLoggedIn = savedEmail != null && savedPassword != null;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
    routes: {
      AppRoutes.home: (context) =>
          HomePage(savedEmail: savedEmail, savedPassword: savedPassword),
      AppRoutes.login: (context) => LoginPage(),
      AppRoutes.signup: (context) => SignUp()
    },
  ));
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
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Homepage'),
          backgroundColor: Colors.blueGrey),
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
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Password: $savedPassword',
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
          ],
        ),
      ),
    );
  }
}
