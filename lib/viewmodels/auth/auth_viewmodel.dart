import 'package:ZenAiYoga/services/auth/auth_service.dart';
import 'package:ZenAiYoga/services/account/account_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ZenAiYoga/routing/app_routes.dart';
import 'package:ZenAiYoga/views/pre_launch_survey_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    // 'email',
    // 'https://www.googleapis.com/auth/contacts.readonly',
    'email',
    'profile',
  ], serverClientId: dotenv.env['GOOGLE_CLIENT_ID']);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> handleSignUp(
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
  ) async {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackbar(context, trans.missingInfor, theme, isError: true);
      return;
    }

    if (password.length < 8) {
      showSnackbar(context, trans.atleast8chars, theme, isError: true);
      return;
    }

    if (password != confirmPassword) {
      showSnackbar(context, trans.passDonotMatch, theme, isError: true);
      return;
    }

    setLoading(true);
    try {
      final response = await register(RegisterRequest(
        email: email,
        password: password,
        username: username,
        re_password: confirmPassword,
      ));

      if (response['status'] == 201) {
        Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
      } else {
        print(response['status']);
        print(response['message']);

        String errorMessage = trans.defaultError;
        if (response['message'] is Map) {
          if (response['message'].containsKey("username")) {
            errorMessage = trans.usernameExists;
          } else if (response['message'].containsKey("email")) {
            errorMessage = trans.emailExists;
          }
        }

        showSnackbar(context, errorMessage, theme, isError: true);
      }
    } catch (e) {
      showSnackbar(context, trans.anError, theme, isError: true);
    }
    setLoading(false);
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
        if (googleUser.photoUrl != null) {
          user?.profile.avatar_url = googleUser.photoUrl;
        }
        print(user);
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

  Future<void> handleResetPassword(BuildContext context, String email) async {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (email.isEmpty) {
      showSnackbar(context, trans.enterEmail, theme, isError: true);
      return;
    }

    setLoading(true);
    try {
      final response = await resetPassword(email);
      if (response['status'] == 204) {
        showSnackbar(context, '${trans.sendResetPasswordTo} $email', theme);
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        showSnackbar(context, trans.invalidEmail, theme, isError: true);
      }
    } catch (e) {
      showSnackbar(context, "${trans.error}: ${e.toString()}", theme,
          isError: true);
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
