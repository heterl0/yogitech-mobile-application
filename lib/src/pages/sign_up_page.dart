import 'package:flutter/material.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/src/routing/app_routes.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/box_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/src/widgets/box_input_field.dart';

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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trans = AppLocalizations.of(context)!;
    // Kiểm tra giao diện hiện tại để chọn hình ảnh phù hợp
    final String imageAsset = theme.brightness == Brightness.dark
        ? 'assets/images/sign-up-bg.png'
        : 'assets/images/sign-up-bg_light.png';

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Đảm bảo AppBar trong suốt không ảnh hưởng đến nội dung
      appBar: AppBar(
        leading: IconButton(
          iconSize: 32.0,
          icon: Icon(Icons.arrow_back,
              color: active), // Màu của biểu tượng mũi tên là màu trắng
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent, // Nền của AppBar trong suốt
        elevation: 0,
      ),
      backgroundColor: theme.colorScheme.onSecondary,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                    trans.signUp,
                    style: h1.copyWith(color: theme.colorScheme.onPrimary),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: usernameController,
                    placeholder: trans.username,
                  ),

                  // BoxInputField(
                  //   controller: emailController,
                  //   placeholder: 'Username',
                  // ),

                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: emailController,
                    placeholder: trans.email,
                  ),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: passwordController,
                    placeholder: trans.password,
                    password: true,
                  ),
                  SizedBox(height: 16.0),
                  BoxInputField(
                    controller: confirmPasswordController,
                    placeholder: trans.confirmPassword,
                    password: true,
                  ),

                  SizedBox(height: 10.0),
                  CustomButton(
                    title: trans.signUp,
                    style: ButtonStyleType.Primary,
                    state: ButtonState
                        .Enabled, // hoặc ButtonState.Disabled để test trạng thái disabled
                    onPressed: () async {
                      _handleSignUp(context);
                    },
                  ),
                  SizedBox(height: 10.0),

                  // google sign in button here

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        trans.haveAccount,
                        style: bd_text.copyWith(color: text),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          trans.signIn,
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

  Future<void> _handleSignUp(BuildContext context) async {
    final trans = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
    });
    final theme = Theme.of(context);
    String enteredUsername = usernameController.text;
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;
    String enteredConfirmPassword = confirmPasswordController.text;

    if (enteredUsername.isEmpty ||
        enteredEmail.isEmpty ||
        enteredPassword.isEmpty ||
        enteredConfirmPassword.isEmpty) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.onSecondary,
          content: Text(
            trans.missingInfor,
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (enteredPassword != enteredConfirmPassword) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.onSecondary,
          content: Text(
            trans.passDonotMatch,
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await register(RegisterRequest(
          email: enteredEmail,
          password: enteredPassword,
          username: enteredUsername,
          re_password: enteredConfirmPassword));
      print(response);
      if (response['status'] == 201) {
        // ScaffoldMessenger.of(context)
        //     .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Register successfully!'),
        //   ),
        // );
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, AppRoutes.verifyEmail);
      } else {
        final errorMessages = response['message'];

        ScaffoldMessenger.of(context).hideCurrentSnackBar(); //

        List<String> allErrors = [];
        for (var key in errorMessages.keys) {
          for (var message in errorMessages[key]) {
            String capitalizedMessage =
                message[0].toUpperCase() + message.substring(1);
            allErrors.add(capitalizedMessage);
          }
        }
        String concatenatedErrors = allErrors.join('\n');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: theme.colorScheme.onSecondary,
            content: Text(
              concatenatedErrors.isEmpty
                  ? trans.failRegister
                  : concatenatedErrors,
              style: bd_text.copyWith(color: theme.colorScheme.onSurface),
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); // Ẩn các thông báo hiện tại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: theme.colorScheme.onSecondary,
          content: Text(
            trans.anError,
            style: bd_text.copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }
}
