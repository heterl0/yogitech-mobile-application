import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService('http://10.66.172.236:8000');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor, // Sử dụng màu nền tối từ theme
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/images/login-sign.png'),
            //   fit: BoxFit.fitWidth,
            //   alignment: Alignment.topCenter,
            // ),
            ),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.login,
              style: h1.copyWith(
                  color: theme
                      .colorScheme.onPrimary), // Sử dụng màu văn bản từ theme
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.0),
            // Thay thế TextField bằng BoxInputField
            BoxInputField(
              controller: emailController,
              placeholder: AppLocalizations.of(context)!.email,
            ),
            SizedBox(height: 16.0),
            // Thay thế TextField bằng BoxInputField
            BoxInputField(
              controller: passwordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Color(0xFF8D8E99),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(44.0),
                  borderSide: BorderSide(color: Color(0xFF8D8E99)),
                ),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 0.0,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.forgotpassword);
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 0.0),
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44.0),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3BE2B0),
                    Color(0xFF4095D0),
                    Color(0xFF5986CC), // Màu gradient từ 100% (8800DC)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Xử lý sự kiện khi nhấn vào nút "Login"
                    _handleLogin(context);
                  },
                  borderRadius: BorderRadius.circular(44.0),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(children: <Widget>[
              Expanded(
                  child: Divider(
                color: stroke, // Sử dụng màu viền từ theme
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.orSignInWith,
                  style: bd_text.copyWith(
                      color: stroke), // Sử dụng màu văn bản từ theme
                ),
              ),
              Expanded(
                  child: Divider(color: stroke)), // Sử dụng màu viền từ theme
            ]),

            // Nút Google Sign In ở đây

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.dontHaveAccount,
                  style: bd_text.copyWith(color: text),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn vào "Sign up"
                    // Chuyển đến trang đăng ký
                    Navigator.pushNamed(context, AppRoutes.signup);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.signUp,
                    style: h3.copyWith(color: primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    // Lấy giá trị từ TextField
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;

    // Kiểm tra rỗng
    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both Email and Password fields'),
        ),
      );
      return;
    }

    try {
      final response = await apiService.login(enteredEmail, enteredPassword);

      // Kiểm tra phản hồi từ API
      if (response['status'] == 'success') {
        // Lưu thông tin đăng nhập và chuyển đến trang chủ
        await saveLoginInfo(enteredEmail, enteredPassword);

        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // Nếu đăng nhập không thành công, hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Invalid email or password'),
          ),
        );
      }
    } catch (e) {
      // Nếu có lỗi xảy ra khi gọi API, hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'An error occurred. Please try again later. ' + e.toString()),
        ),
      );
    }
  }
}
