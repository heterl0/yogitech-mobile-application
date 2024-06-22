import 'package:flutter/material.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/src/routing/app_routes.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
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
              state: ButtonState
                  .Enabled, // hoặc ButtonState.Disabled để test trạng thái disabled
              onPressed: () {
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
                    // Xử lý sự kiện khi nhấn vào "Sign up"
                    // Chuyển đến trang đăng ký
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
    );
  }

  Future<void> _handleResetPassword(BuildContext context, String email) async {
    final trans = AppLocalizations.of(context)!;

    try {
      await resetPassword(email);
      // Hiển thị thông báo thành công và chuyển trang
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(trans.sendResetPasswordTo + ' $email'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppRoutes.login, (Route<dynamic> route) => false);
    } catch (e) {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
