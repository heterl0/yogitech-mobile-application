import 'package:YogiTech/src/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/src/routing/app_routes.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    // Kiểm tra giao diện hiện tại để chọn hình ảnh phù hợp
    final String imageAsset = theme.brightness == Brightness.dark
        ? 'assets/images/login-sign.png'
        : 'assets/images/login-sign_light.png';
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Đảm bảo AppBar trong suốt không ảnh hưởng đến nội dung
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.all(22.0),
          iconSize: 32.0,
          icon: Icon(Icons.arrow_back,
              color: Colors.white), // Màu của biểu tượng mũi tên là màu trắng
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent, // Nền của AppBar trong suốt
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
                BoxButton(
                  title: trans.request,
                  style: ButtonStyleType.Primary,
                  state: isLoading ? ButtonState.Disabled : ButtonState.Enabled,
                  onPressed: isLoading
                      ? null
                      : () {
                          _handleResetPassword(context, emailController.text);
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
                      trans.orSignInWith,
                      style: bd_text.copyWith(color: text),
                    ),
                  ),
                  Expanded(child: Divider(color: text)),
                ]),
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
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _handleResetPassword(BuildContext context, String email) async {
    final trans = AppLocalizations.of(context)!;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              ''), // Giả sử trans.enterEmail là thông báo "Vui lòng nhập email"
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(trans.sendResetPasswordTo + ' $email'),
          backgroundColor: Colors.green,
        ),
      );
      pushWithNavBar(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
