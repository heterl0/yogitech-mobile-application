import 'package:flutter/material.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_input_field.dart';
import 'package:yogi_application/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordPage({super.key});
  
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
            // Container(
            //   height: 50.0,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(44.0),
            //     gradient: LinearGradient(
            //       colors: [
            //         Color(0xFF3BE2B0),
            //         Color(0xFF4095D0),
            //         Color(0xFF5986CC),
            //       ],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       stops: [0.0, 0.5, 1.0],
            //     ),
            //   ),
            //   child: Material(
            //     color: Colors.transparent,
            //     child: InkWell(
            //       onTap: () {
            //         // Xử lý sự kiện khi nhấn vào nút "Send OTP"
            //         _handleSendOTP(context, emailController.text);
            //       },
            //       borderRadius: BorderRadius.circular(44.0),
            //       child: Center(
            //         child: Text(
            //           'Send OTP',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 18.0,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            BoxButton(
              title: trans.sendOTP,
              style: ButtonStyleType.Primary,
              state: ButtonState
                  .Enabled, // hoặc ButtonState.Disabled để test trạng thái disabled
              onPressed: () {
                _handleSendOTP(context, emailController.text);
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

  void _handleSendOTP(BuildContext context, String email) {
    final trans = AppLocalizations.of(context)!;
    // Xử lý sự kiện gửi OTP
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${trans.sendOTP} $email'),
      ),
    );
  }
}
