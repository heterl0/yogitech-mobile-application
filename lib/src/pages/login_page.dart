import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:yogi_application/main.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService('https://api.yogitech.me');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Kiểm tra giao diện hiện tại để chọn hình ảnh phù hợp
    final String imageAsset = theme.brightness == Brightness.dark
        ? 'assets/images/login-sign.png'
        : 'assets/images/login-sign_light.png';

    return Scaffold(
      backgroundColor: theme.colorScheme.onSecondary,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageAsset),
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
              style: h1.copyWith(color: theme.colorScheme.onPrimary),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.0),
            // TextField(
            //   controller: emailController,
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: Colors.white.withOpacity(0),
            //     hintText: 'Email',
            //     hintStyle: TextStyle(color: Color(0xFF8D8E99)),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(44.0),
            //       borderSide: BorderSide(color: Color(0xFF8D8E99)),
            //     ),
            //   ),
            //   style: TextStyle(color: Colors.white),
            // ),
            BoxInputField(
              controller: emailController,
              placeholder: 'Email',
            ),

            SizedBox(height: 16.0),
            // TextField(
            //   controller: passwordController,
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: Colors.white.withOpacity(0),
            //     hintText: 'Password',
            //     hintStyle: TextStyle(
            //       color: Color(0xFF8D8E99),
            //     ),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(44.0),
            //       borderSide: BorderSide(color: Color(0xFF8D8E99)),
            //     ),
            //   ),
            //   obscureText: true,
            //   style: TextStyle(color: Colors.white),
            // ),
            SizedBox(
              height: 0.0,
            ),

            BoxInputField(
              controller: passwordController,
              placeholder: 'Password',
              password: true,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.forgotpassword);
                },
                child: Text(
                  'Forgot password?',
                  style: bd_text.copyWith(color: theme.primaryColor),
                ),
              ),
            ),

            SizedBox(height: 0.0),
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
                color: text,
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Or sign in with",
                  style: bd_text.copyWith(color: text),
                ),
              ),
              Expanded(child: Divider(color: text)),
            ]),

            // google sign in button here

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
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;
    final dio = Dio();

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in both Email and Password fields'),
        ),
      );
      return;
    }

    try {
      var dio = Dio();
      Response response = await dio.post(
        'https://api.yogitech.me/api/v1/auth/login/',
        data: {'email': enteredEmail, 'password': enteredPassword},
      );

      print(
          'Login Response: ${response.data}'); // Print the entire response data
      // Check if response data is not null and contains a 'status' key
      if (response.data != null && response.data['status'] == 'success') {
        await saveLoginInfo(enteredEmail, enteredPassword);
        Navigator.pushReplacementNamed(context, AppRoutes.homepage);
      } else {
        // If response data is not null, show the message if available, otherwise show a default message

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(response.data?['message'] ?? 'Invalid email or password'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'An error occurred. Please try again later. ' + e.toString()),
        ),
      );
    }
  }
}
