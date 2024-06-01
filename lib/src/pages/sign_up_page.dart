import 'package:flutter/material.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/features/api_service.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/box_button.dart';

class SignUp extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiService apiService = ApiService('http://127.0.0.1:8000');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Kiểm tra giao diện hiện tại để chọn hình ảnh phù hợp
    final String imageAsset = theme.brightness == Brightness.dark
        ? 'assets/images/sign-up-bg.png'
        : 'assets/images/sign-up-bg_light.png';

    return MaterialApp(
      home: Scaffold(
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
                'Sign up',
                style: h1.copyWith(color: theme.colorScheme.onPrimary),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16.0),
              // TextField(
              //   decoration: InputDecoration(
              //     filled: true,
              //     fillColor: Colors.white.withOpacity(0),
              //     hintText: 'Username',
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
                placeholder: 'Username',
              ),

              SizedBox(height: 16.0),
              TextField(
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
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0),
                  hintText: 'Confirm password',
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

              SizedBox(height: 10.0),
              BoxButton(
                title: 'Sign up',
                style: ButtonStyleType.Primary,
                state: ButtonState
                    .Enabled, // hoặc ButtonState.Disabled để test trạng thái disabled
                onPressed: () {
                  _handleSignUp(context);
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
                    "You have an account? ",
                    style: bd_text.copyWith(color: text),
                  ),
                  TextButton(
                    onPressed: () {
                      // Xử lý sự kiện khi nhấn vào "Sign in"

                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Sign in',
                      style: h3.copyWith(color: primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp(BuildContext context) async {
    String enteredUsername = usernameController.text;
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;
    String enteredConfirmPassword = confirmPasswordController.text;

    if (enteredUsername.isEmpty ||
        enteredEmail.isEmpty ||
        enteredPassword.isEmpty ||
        enteredConfirmPassword.isEmpty) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    if (enteredPassword != enteredConfirmPassword) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    try {
      final response = await apiService.register(
        enteredUsername,
        enteredEmail,
        enteredPassword,
        enteredConfirmPassword,
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Register successfully!'),
          ),
        );
        await saveLoginInfo(enteredEmail, enteredPassword);
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context)
            .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to register'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurs, please try later'),
        ),
      );
      print('Error: $e');
    }
  }
}
