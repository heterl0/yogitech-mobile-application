import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoxInputField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool password;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final RegExp? regExp;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isSmall; // Thêm thuộc tính này

  const BoxInputField(
      {super.key,
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
      this.onChanged,
      this.errorText = 'Invalid input',
      this.isSmall = false, // Giá trị mặc định là false
      this.onSubmitted});

  @override
  _BoxInputFieldState createState() => _BoxInputFieldState();
}

class _BoxInputFieldState extends State<BoxInputField> {
  bool _showPassword = false;
  bool _isFocused = false;
  bool _hasError = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder get circleBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            widget.isSmall ? 30 : 44), // Thay đổi kích thước borderRadius
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
    final errorText = (widget.regExp != null &&
            widget.controller.text.isNotEmpty &&
            !widget.regExp!.hasMatch(widget.controller.text))
        ? widget.errorText
        : null;

    _hasError = errorText != null;

    final fontSize = widget.isSmall ? 14.0 : 16.0;
    final contentPadding = widget.isSmall
        ? const EdgeInsets.symmetric(vertical: 10, horizontal: 12)
        : const EdgeInsets.symmetric(vertical: 14, horizontal: 16);
    final iconSize = widget.isSmall ? 16.0 : 24.0;
    final height = widget.isSmall ? 40.0 : 50.0;

    return SizedBox(
      height: height, // Đặt chiều cao của SizedBox
      child: TextField(
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        controller: widget.controller,
        style: TextStyle(
          fontFamily: 'ReadexPro',
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.onPrimary,
        ),
        obscureText: widget.password && !_showPassword,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: TextStyle(
            fontFamily: 'ReadexPro',
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          contentPadding: contentPadding,
          filled: true,
          fillColor: theme.colorScheme.surface,
          prefixIcon: widget.leading != null
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: IconTheme(
                    data: IconThemeData(color: getBorderColor(context)),
                    child: widget.leading!,
                  ),
                )
              : null,
          suffixIcon: widget.password
              ? GestureDetector(
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: getBorderColor(context),
                      size: iconSize,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                )
              : (widget.trailing != null
                  ? SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: IconTheme(
                        data: IconThemeData(color: getBorderColor(context)),
                        child: widget.trailing!,
                      ),
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
          errorStyle: TextStyle(
            fontFamily: 'ReadexPro',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}
