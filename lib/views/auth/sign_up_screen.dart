import 'package:YogiTech/routing/app_routes.dart';
import 'package:YogiTech/shared/app_colors.dart';
import 'package:YogiTech/shared/styles.dart';
import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../viewmodels/auth/auth_viewmodel.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    final authViewModel = Provider.of<AuthViewModel>(context);
    final String imageAsset = theme.brightness == Brightness.dark
        ? 'assets/images/login-sign.png'
        : 'assets/images/login-sign_light.png';

    return Scaffold(
      backgroundColor: theme.colorScheme.onSecondary,
      body: Stack(
        children: [
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
                  trans.signUp,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary),
                ),
                SizedBox(height: 16.0),
                BoxInputField(
                    controller: usernameController,
                    placeholder: trans.username),
                SizedBox(height: 16.0),
                BoxInputField(
                    controller: emailController, placeholder: trans.email),
                SizedBox(height: 16.0),
                BoxInputField(
                    controller: passwordController,
                    placeholder: trans.password,
                    password: true),
                SizedBox(height: 16.0),
                BoxInputField(
                    controller: confirmPasswordController,
                    placeholder: trans.confirmPassword,
                    password: true),
                SizedBox(height: 16.0),
                CustomButton(
                  title: trans.signUp,
                  style: ButtonStyleType.Primary,
                  state: ButtonState.Enabled,
                  onPressed: () => authViewModel.handleSignUp(
                    context,
                    usernameController,
                    emailController,
                    passwordController,
                    confirmPasswordController,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      trans.haveAccount,
                      style: bd_text.copyWith(color: text),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      child: Text(
                        trans.login,
                        style: h3.copyWith(color: primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (authViewModel.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
