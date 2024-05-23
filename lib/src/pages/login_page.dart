import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/widgets/box_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService('http://10.66.172.236:8000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d1f29),
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
              style: h1.copyWith(color: active),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0),
                hintText: 'Email',
                hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(44.0),
                  borderSide: BorderSide(color: Color(0xFF8D8E99)),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16.0),
            TextField(
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
                color: Colors.white,
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Or sign in with",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(child: Divider(color: Colors.white)),
            ]),

            // Nút Google Sign In ở đây

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You don't have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Xử lý sự kiện khi nhấn vào "Sign up"
                    // Chuyển đến trang đăng ký
                    Navigator.pushNamed(context, AppRoutes.signup);
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
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
