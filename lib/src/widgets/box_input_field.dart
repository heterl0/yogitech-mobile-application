import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart';

class BoxInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool password;

  BoxInputField({
    Key? key,
    required this.controller,
    this.placeholder = '',
    this.leading,
    this.trailing,
    this.password = false,
  }) : super(key: key);

  @override
  _BoxInputFieldState createState() => _BoxInputFieldState();
}

class _BoxInputFieldState extends State<BoxInputField> {
  bool _showPassword = false;

  OutlineInputBorder get circleBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(44),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: widget.controller,
      style: TextStyle(
        fontFamily: 'ReadexPro',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface, // Sử dụng màu văn bản từ theme
      ),
      obscureText: widget.password && !_showPassword,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          fontFamily: 'ReadexPro',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.secondary, // Sử dụng màu gợi ý từ theme
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: theme.colorScheme.surface, // Sử dụng màu nền từ theme
        prefixIcon: widget.leading,
        suffixIcon: widget.password
            ? GestureDetector(
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: theme
                      .colorScheme.secondary, // Sử dụng màu biểu tượng từ theme
                ),
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : widget.trailing,
        border: circleBorder.copyWith(
            borderSide: BorderSide(
                color:
                    theme.colorScheme.secondary)), // Sử dụng màu viền từ theme
        focusedBorder: circleBorder.copyWith(
            borderSide: BorderSide(
                color: theme.colorScheme
                    .primary)), // Sử dụng màu viền khi focus từ theme
        errorBorder: circleBorder.copyWith(
            borderSide: BorderSide(
                color: theme.colorScheme
                    .error)), // Sử dụng màu viền khi có lỗi từ theme
        enabledBorder: circleBorder.copyWith(
            borderSide: BorderSide(
                color: theme
                    .dividerColor)), // Sử dụng màu viền khi enabled từ theme
      ),
    );
  }
}
