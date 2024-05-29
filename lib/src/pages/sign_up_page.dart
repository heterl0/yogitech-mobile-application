import 'package:flutter/material.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/features/api_service.dart';

class SignUp extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiService apiService = ApiService('http://127.0.0.1:8000');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0d1f29),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sign-up-bg.png'),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0),
                  hintText: 'Username',
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
                      // sự kiện handle sign up
                      _handleSignUp(context);
                    },
                    borderRadius: BorderRadius.circular(44.0),
                    child: Center(
                      child: Text(
                        'Sign up',
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

// google sign in button here

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Xử lý sự kiện khi nhấn vào "Sign in"

                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Sign in',
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
