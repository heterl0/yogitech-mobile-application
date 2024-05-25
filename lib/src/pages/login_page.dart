import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/shared/styles.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService('http://10.66.172.236:8000');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: darkbg, // Sử dụng màu nền tối từ theme
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login-sign.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login',
              style: h1.copyWith(
                  color: theme
                      .colorScheme.onPrimary), // Sử dụng màu văn bản từ theme
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.0),
            // Thay thế TextField bằng BoxInputField
            BoxInputField(
              controller: emailController,
              placeholder: 'Email',
            ),
            SizedBox(height: 16.0),
            // Thay thế TextField bằng BoxInputField
            BoxInputField(
              controller: passwordController,
              placeholder: 'Password',
              password: true,
            ),

            SizedBox(height: 16.0),

            // Thay thế nút Login hiện tại bằng BoxButton
            BoxButton(
              title: 'Login',
              style: ButtonStyleType.Primary,
              state: ButtonState
                  .Enabled, // hoặc ButtonState.Disabled để test trạng thái disabled
              onPressed: () {
                _handleLogin(context);
              },
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
                  'Or sign in with',
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
                  "You don't have an account? ",
                  style: bd_text.copyWith(color: text),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn vào "Sign up"
                    // Chuyển đến trang đăng ký
                    Navigator.pushNamed(context, AppRoutes.signup);
                  },
                  child: Text(
                    'Sign up',
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
        // Lưu thông tin đăng nhập
        await saveLoginInfo(enteredEmail, enteredPassword);

        // Chuyển đến trang chủ
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
              'An error occurred. Please try again later. ${e.toString()}'),
        ),
      );
    }
  }
}
