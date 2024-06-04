import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:yogi_application/src/shared/styles.dart';

class BoxInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool password;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final RegExp? regExp;
  final VoidCallback? onTap;

  BoxInputField({
    Key? key,
    required this.controller,
    this.placeholder = '',
    this.leading,
    this.trailing,
    this.password = false,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.regExp,
    this.onTap,
  }) : super(key: key);

  @override
  _BoxInputFieldState createState() => _BoxInputFieldState();
}

class _BoxInputFieldState extends State<BoxInputField> {
  bool _showPassword = false;
  bool _isFocused = false; // Theo dõi trạng thái focus
  bool _hasError = false; // Theo dõi trạng thái lỗi
  FocusNode _focusNode = FocusNode();

  OutlineInputBorder get circleBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(44),
      );

  Color getBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    if (_hasError) {
      return theme.colorScheme.error;
    } else if (_isFocused) {
      return theme.primaryColor;
    } else {
      return theme.colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorText = widget.regExp != null &&
            widget.controller.text.isNotEmpty &&
            !widget.regExp!.hasMatch(widget.controller.text)
        ? 'Invalid phone number'
        : null;

    return TextField(
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      controller: widget.controller,
      style: TextStyle(
        fontFamily: 'ReadexPro',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface,
      ),
      obscureText: widget.password && !_showPassword,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          fontFamily: 'ReadexPro',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: text,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: theme.colorScheme.background,
        prefixIcon: widget.leading != null
            ? IconTheme(
                data: IconThemeData(
                    color: getBorderColor(context)), // Use function for color
                child: widget.leading!,
              )
            : null,
        suffixIcon: widget.password
            ? GestureDetector(
                child: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: getBorderColor(context), // Use function for color
                ),
                onTap: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : (widget.trailing != null
                ? IconTheme(
                    data: IconThemeData(
                        color:
                            getBorderColor(context)), // Use function for color
                    child: widget.trailing!,
                  )
                : null),
        border: circleBorder.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.secondary),
        ),
        focusedBorder: circleBorder.copyWith(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        errorBorder: circleBorder.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        enabledBorder: circleBorder.copyWith(
          borderSide: BorderSide(color: theme.colorScheme.secondary),
        ),
        errorText: errorText,
        errorStyle: min_cap.copyWith(color: error),
      ),
    );
  }
}
