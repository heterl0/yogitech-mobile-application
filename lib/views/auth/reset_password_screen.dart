import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0d1f29),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login-sign.png'),
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
              trans.resetPassword,
              style: TextStyle(
                color: active,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: newPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: active.withOpacity(0),
                hintText: trans.newPassword,
                hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(44.0),
                  borderSide: BorderSide(color: Color(0xFF8D8E99)),
                ),
              ),
              style: TextStyle(color: active),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmNewPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: active.withOpacity(0),
                hintText: trans.confirmNewPassword,
                hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(44.0),
                  borderSide: BorderSide(color: Color(0xFF8D8E99)),
                ),
              ),
              style: TextStyle(color: active),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44.0),
                gradient: LinearGradient(
                  colors: const [
                    Color(0xFF3BE2B0),
                    Color(0xFF4095D0),
                    Color(0xFF5986CC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Xử lý sự kiện khi nhấn vào nút "Reset"
                  },
                  borderRadius: BorderRadius.circular(44.0),
                  child: Center(
                    child: Text(
                      trans.reset,
                      style: TextStyle(
                        color: active,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _handleSendOTP(
  //     BuildContext context, String email, AppLocalizations trans) {
  //   // Xử lý sự kiện gửi OTP
  //   final theme = Theme.of(context);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       backgroundColor: theme.colorScheme.onSecondary,
  //       content: Text(
  //         '${trans.sendOTP} $email',
  //         style: bd_text.copyWith(color: theme.colorScheme.onSurface),
  //       ),
  //     ),
  //   );
  // }
}
