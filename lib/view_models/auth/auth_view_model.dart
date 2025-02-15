import 'package:YogiTech/services/auth/auth_service.dart';
import 'package:YogiTech/services/account/account_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:YogiTech/routing/app_routes.dart';
import 'package:YogiTech/views/pre_launch_survey_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ], serverClientId: dotenv.env['GOOGLE_CLIENT_ID']);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> handleGoogleSignIn(
      BuildContext context, AppLocalizations trans) async {
    final theme = Theme.of(context);
    setLoading(true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser!.authentication;

      final accessToken =
          await loginGoogle(googleSignInAuthentication.idToken ?? "");

      if (accessToken != null) {
        _googleSignIn.signOut();
        final user = await getUser();
        if (user != null && user.active_status == 1) {
          if (user.profile.first_name == null ||
              user.profile.last_name == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PrelaunchSurveyPage()),
            );
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.firstScreen);
          }
        } else {
          showSnackbar(context, trans.baned, theme, isError: true);
        }
      } else {
        showSnackbar(context, trans.usingEmail, theme);
        _googleSignIn.signOut();
      }
    } catch (e) {
      showSnackbar(context, '${trans.anError} $e', theme);
      _googleSignIn.signOut();
    }

    setLoading(false);
  }

  Future<void> logout(BuildContext context) async {
    try {
      await clearToken();
      await clearAccount();
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppRoutes.login, (Route<dynamic> route) => false);
    } catch (e) {
      print("Lỗi khi logout: $e");
    }
  }

  Future<void> handleLogin(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showSnackbar(context, trans.dontEmpty, theme, isError: true);
      return;
    }

    setLoading(true);
    try {
      final accessToken = await login(email, password);

      if (accessToken != null && accessToken is String) {
        final user = await getUser();
        if (user != null && user.active_status == 1) {
          if (user.profile.first_name == null ||
              user.profile.last_name == null ||
              user.profile.bmi == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PrelaunchSurveyPage()),
            );
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.firstScreen);
          }
        } else {
          showSnackbar(context, trans.baned, theme, isError: true);
        }
      } else if (accessToken['status'] == 403) {
        Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
      } else {
        showSnackbar(context, trans.doesntexist, theme);
      }
    } catch (e) {
      showSnackbar(context, '$e', theme);
    }
    setLoading(false);
  }

  void showSnackbar(BuildContext context, String message, ThemeData theme,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : theme.colorScheme.onSecondary,
        content:
            Text(message, style: TextStyle(color: theme.colorScheme.onSurface)),
      ),
    );
  }
}
