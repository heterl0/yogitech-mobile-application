import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:ZenAiYoga/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTP_Page extends StatelessWidget {
  final TextEditingController OTPcontroller = TextEditingController();

  OTP_Page({super.key});

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
              trans.otpConfirm,
              style: TextStyle(
                color: active,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: OTPcontroller,
              decoration: InputDecoration(
                filled: true,
                fillColor: active.withOpacity(0),
                hintText: 'OTP',
                hintStyle: TextStyle(color: Color(0xFF8D8E99)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(44.0),
                  borderSide: BorderSide(color: Color(0xFF8D8E99)),
                ),
              ),
              style: TextStyle(color: active),
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // resend new OTP
                },
                child: Text(
                  trans.resendOTP,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44.0),
                gradient: gradient,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Xử lý sự kiện khi nhấn vào nút "Send OTP"
                    _handleSendOTP(context, OTPcontroller.text);
                  },
                  borderRadius: BorderRadius.circular(44.0),
                  child: Center(
                    child: Text(
                      trans.confirm,
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
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  void _handleSendOTP(BuildContext context, String email) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;

    // Xử lý sự kiện gửi OTP
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colorScheme.onSecondary,
        content: Text(
          '${trans.sendOTP} $email',
          style: bd_text.copyWith(color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
