import 'package:YogiTech/src/shared/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String placeholder;
  final List<String> items;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String?>? onChanged;

  const CustomDropdownFormField({
    super.key,
    required this.controller,
    required this.items,
    this.placeholder = '',
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  bool _isFocused = false;
  final bool _hasError = false;
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _inputKey = GlobalKey();

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

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _inputKey,
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            dropdownColor: theme.colorScheme.onSecondary,
            isExpanded: true,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontFamily: 'ReadexPro',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              filled: true,
              fillColor: theme.colorScheme.surface,
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
              errorStyle: TextStyle(
                fontFamily: 'ReadexPro',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.error,
              ),
            ),
            value:
                widget.controller.text.isEmpty ? null : widget.controller.text,
            hint: Text(
              widget.placeholder,
              style: TextStyle(
                fontFamily: 'ReadexPro',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            items: widget.items
                .map((label) => DropdownMenuItem(
                      value: label,
                      child: Text(label,
                          style: bd_text.copyWith(
                              color: theme.colorScheme.onPrimary)),
                    ))
                .toList(),
            borderRadius: BorderRadius.circular(16),
            elevation: 8,
            onChanged: widget.readOnly
                ? null
                : (value) {
                    setState(() {
                      widget.controller.text = value!;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
          ),
        ),
      ),
    );
  }
}
