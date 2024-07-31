import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/src/routing/app_routes.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/src/pages/pre_launch_survey_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
    final trans = AppLocalizations.of(context)!;

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
                    trans.login,
                    style: h1.copyWith(color: theme.colorScheme.onPrimary),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: emailController,
                    placeholder: trans.email,
                  ),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: passwordController,
                    placeholder: trans.password,
                    password: true,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotpassword);
                      },
                      child: Text(
                        trans.forgotPassword,
                        style: bd_text.copyWith(
                            color: theme.primaryColor, height: 1),
                      ),
                    ),
                  ),
                  CustomButton(
                    title: trans.login,
                    style: ButtonStyleType.Primary,
                    state: ButtonState.Enabled,
                    onPressed: () async {
                      _handleLogin(context);
                      // print(await getExercises());
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
                            trans.orSignInWith,
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
                            await _handleGoogleSignIn(trans);
                          },
                          text: trans.loginWithGoogle,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            trans.dontHaveAccount,
                            style: bd_text.copyWith(color: text),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                            child: Text(
                              trans.signUp,
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

  Future<void> _handleGoogleSignIn(AppLocalizations trans) async {
    final theme = Theme.of(context);
    setState(() {
      _isLoading = true;
    });

    try {
      await _googleSignIn.signIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser!.authentication;
      try {
        print(googleSignInAuthentication.idToken ?? "");
        final accessToken =
            await loginGoogle(googleSignInAuthentication.idToken ?? "");

        if (accessToken != null) {
          _googleSignIn.signOut();
          final user = await getUser();
          if (user != null && user.active_status == 1) {
            if (user.profile.first_name == null ||
                user.profile.last_name == null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PrelaunchSurveyPage(),
                ),
              );
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.firstScreen);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  trans.baned,
                  style: bd_text.copyWith(color: active),
                ),
                backgroundColor: error,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: theme.colorScheme.onSecondary,
              content: Text(
                trans.usingEmail,
                style: bd_text.copyWith(color: theme.colorScheme.onSurface),
              ),
            ),
          );
          _googleSignIn.signOut();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: theme.colorScheme.onSecondary,
            content: Text(
              '${trans.anError} $e',
              style: bd_text.copyWith(color: theme.colorScheme.onSurface),
            ),
          ),
        );
        _googleSignIn.signOut();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: theme.colorScheme.onSecondary,
            content: Text('${trans.failSignIn} $error',
                style: bd_text.copyWith(color: theme.colorScheme.onSurface))),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleLogin(BuildContext context) async {
    final theme = Theme.of(context);
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;
    final trans = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
    });
    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: error,
            content: Text(trans.dontEmpty,
                style: bd_text.copyWith(color: theme.colorScheme.onSurface))),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      final accessToken = await login(enteredEmail, enteredPassword);

      if (accessToken != null && accessToken is String) {
        final user = await getUser();

        if (user != null && user.active_status == 1) {
          if ((user.profile.first_name == null ||
              user.profile.last_name == null ||
              user.profile.bmi == null)) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PrelaunchSurveyPage(),
              ),
            );
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.firstScreen);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: theme.colorScheme.onSecondary,
                content: Text(
                  trans.baned,
                  style: bd_text.copyWith(color: theme.colorScheme.onSurface),
                )),
          );
        }
      } else if (accessToken['status'] == 403) {
        Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: theme.colorScheme.onSecondary,
              content: Text(
                trans.doesntexist,
                style: bd_text.copyWith(color: theme.colorScheme.onSurface),
              )),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: theme.colorScheme.onSecondary,
            content: Text(
              '$e',
              style: bd_text.copyWith(color: theme.colorScheme.onSurface),
            )),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
