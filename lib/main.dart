import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/shared_preferences_util.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, String?> loginInfo = await getLoginInfo();
  String? savedEmail = loginInfo['email'];
  String? savedPassword = loginInfo['password'];

  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    initialRoute: savedEmail != null && savedPassword != null
        ? AppRoutes.home
        : AppRoutes.login,
    routes: {
      AppRoutes.home: (context) => HomePage(),
      AppRoutes.login: (context) => LoginPage(),
      AppRoutes.signup: (context) => SignUp()
    },
  ));
}

class HomePage extends StatelessWidget {
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
            ElevatedButton(
              child: const Text('Login page'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
            ),
            SizedBox(height: 20), // Thêm một khoảng cách giữa các nút
            ElevatedButton(
              child: const Text('Sign Up page'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signup);
              },
            ),
            SizedBox(height: 20), // Thêm một khoảng cách giữa các nút
            ElevatedButton(
              child: const Text('Log out'),
              onPressed: () {
                clearLoginInfo(); // Xóa thông tin đăng nhập
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
