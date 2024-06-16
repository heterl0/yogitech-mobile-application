import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
import 'package:yogi_application/api/blog/blog_service.dart';
import 'package:yogi_application/api/event/event_service.dart';
import 'package:yogi_application/api/exercise/exercise_service.dart';
import 'package:yogi_application/api/notification/notification_service.dart';
import 'package:yogi_application/api/pose/pose_service.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ], serverClientId: dotenv.env['GOOGLE_CLIENT_ID']);
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String imageAsset = theme.brightness == Brightness.dark
        ? 'assets/images/login-sign.png'
        : 'assets/images/login-sign_light.png';

    return Scaffold(
      backgroundColor: theme.colorScheme.onSecondary,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                  BoxInputField(
                    controller: emailController,
                    placeholder: 'Email',
                  ),
                  SizedBox(height: 16.0),
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
                  BoxButton(
                    title: 'Login',
                    style: ButtonStyleType.Primary,
                    state: ButtonState.Enabled,
                    onPressed: () async {
                      // _handleLogin(context);
                      print(await getEvents());
                    },
                  ),
                  SizedBox(height: 10.0),
                  Column(
                    children: [
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
                        const Expanded(child: Divider(color: text)),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: stroke,
                            width: 2, // Adjust the border width as needed
                          ),
                        ),
                        child: SocialLoginButton(
                          backgroundColor: theme.scaffoldBackgroundColor,
                          height: 50,
                          borderRadius: 30,
                          fontSize: 20,
                          textColor: theme.colorScheme.onPrimary,
                          buttonType: SocialLoginButtonType.google,
                          onPressed: () async {
                            // var user = await LoginGoogle.login();
                            // if (user != null) {
                            //   print(user.displayName);
                            // }
                            await _handleGoogleSignIn();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You don't have an account? ",
                            style: bd_text.copyWith(color: text),
                          ),
                          TextButton(
                            onPressed: () {
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
                ],
              ),
            ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _googleSignIn.signIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text(
      //     'Login: $googleUser',
      //   )),
      // );
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser!.authentication;
      try {
        final user =
            await loginGoogle(googleSignInAuthentication.idToken ?? "");

        if (user != null &&
            user.accessToken.isNotEmpty &&
            user.refreshToken.isNotEmpty) {
          Navigator.pushReplacementNamed(context, AppRoutes.homepage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('An error occurred. Please try again later.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('An error occurred. Please try again later. $e')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Failed to sign in: $error',
        )),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future signIn() async {
    String savedEmail = '';
    String savedPassword = '';

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) =>
          HomePage(savedEmail: savedEmail, savedPassword: savedPassword),
    ));
  }

  Future<void> _handleLogin(BuildContext context) async {
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;

    setState(() {
      _isLoading = true;
    });
    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill in both Email and Password fields')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final user = await login(enteredEmail, enteredPassword);

      if (user != null &&
          user.accessToken.isNotEmpty &&
          user.refreshToken.isNotEmpty) {
        Navigator.pushReplacementNamed(context, AppRoutes.homepage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred. Please try again later. $e')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
