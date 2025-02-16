import 'package:YogiTech/widgets/box_input_field.dart';
import 'package:YogiTech/widgets/box_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../view_models/auth/auth_viewmodel.dart';

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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 32.0,
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: theme.colorScheme.onSecondary,
      body: authViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(trans.signUp,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                ],
              ),
            ),
    );
  }
}
