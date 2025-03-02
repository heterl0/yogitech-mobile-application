import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:YogiTech/routing/app_routes.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final authViewModel = Provider.of<AuthViewModel>(context);
    final String imageAsset = theme.brightness == Brightness.light
        ? 'assets/images/login-sign_light.png'
        : 'assets/images/login-sign.png';

    return Scaffold(
      backgroundColor: theme.colorScheme.onSecondary,
      body: Stack(
        children: [
          // Nội dung chính
          Container(
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
                  onSubmitted: (_) async {
                    await _handleLogin(authViewModel, context);
                  },
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
                    await _handleLogin(authViewModel, context);
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
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: stroke,
                          width: 2,
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
                          await _handleGoogleSignIn(
                              authViewModel, context, trans);
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

          // Màn hình loading với hiệu ứng mờ
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Làm mờ nền
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white, // Màu loading
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Xử lý đăng nhập email
  Future<void> _handleLogin(
      AuthViewModel authViewModel, BuildContext context) async {
    setState(() {
      _isLoading = true; // Hiển thị loading
    });

    await authViewModel.handleLogin(
        context, emailController, passwordController);

    setState(() {
      _isLoading = false; // Ẩn loading sau khi hoàn tất
    });
  }

  /// Xử lý đăng nhập Google
  Future<void> _handleGoogleSignIn(AuthViewModel authViewModel,
      BuildContext context, AppLocalizations trans) async {
    setState(() {
      _isLoading = true; // Hiển thị loading
    });

    await authViewModel.handleGoogleSignIn(context, trans);

    setState(() {
      _isLoading = false; // Ẩn loading sau khi hoàn tất
    });
  }
}
