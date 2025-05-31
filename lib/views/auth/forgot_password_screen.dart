import 'package:flutter/material.dart';
import 'package:ZenAiYoga/routing/app_routes.dart';
import 'package:ZenAiYoga/shared/styles.dart';
import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:ZenAiYoga/widgets/box_input_field.dart';
import 'package:ZenAiYoga/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    final String imageAsset = theme.brightness == Brightness.dark
        ? 'assets/images/login-sign.png'
        : 'assets/images/login-sign_light.png';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 32.0,
          icon: Icon(Icons.arrow_back, color: active),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                  trans.forgotPasswordTitle,
                  style: h1.copyWith(color: theme.colorScheme.onPrimary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                BoxInputField(
                  controller: emailController,
                  placeholder: trans.email,
                ),
                SizedBox(height: 20.0),
                CustomButton(
                  title: trans.request,
                  style: ButtonStyleType.Primary,
                  state: authViewModel.isLoading
                      ? ButtonState.Disabled
                      : ButtonState.Enabled,
                  onPressed: authViewModel.isLoading
                      ? null
                      : () {
                          authViewModel.handleResetPassword(
                              context, emailController.text);
                        },
                ),
                SizedBox(height: 10.0),
                Row(children: <Widget>[
                  Expanded(child: Divider(color: text)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(trans.orSignInWith,
                        style: bd_text.copyWith(color: text)),
                  ),
                  Expanded(child: Divider(color: text)),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(trans.dontHaveAccount,
                        style: bd_text.copyWith(color: text)),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.signup),
                      child: Text(trans.signUp,
                          style: h3.copyWith(color: primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (authViewModel.isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
