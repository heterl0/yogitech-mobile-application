import 'package:flutter/material.dart';
import 'package:YogiTech/src/routing/app_routes.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/EmailOpen.png', // Thay đổi đường dẫn đến hình ảnh của bạn
                width: 120,
                height: 120,
              ),
              Text(
                trans.verifyEmail,
                style: h1.copyWith(color: theme.colorScheme.onPrimary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  trans.checkYourEmail,
                  style: bd_text.copyWith(color: text),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: CustomButton(
                  title: trans.returnLogin,
                  style: ButtonStyleType.Primary,
                  state: ButtonState.Enabled,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSendOTP(BuildContext context, String login) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    // Xử lý sự kiện gửi OTP
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colorScheme.onSecondary,
        content: Text(
          '${trans.returnLogin} $login',
          style: bd_text.copyWith(color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
