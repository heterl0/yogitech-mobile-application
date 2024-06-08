import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

class CustomDropdownFormField extends StatefulWidget {
  final String placeholder;
  final List<String> itemsValue;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final String initialDropdownValue;

  CustomDropdownFormField({
    Key? key,
    required this.controller,
    required this.itemsValue,
    this.placeholder = '',
    this.readOnly = false,
    this.onTap,
    this.initialDropdownValue = '',
  }) : super(key: key);

  @override
  _CustomDropdownFormFieldState createState() =>
      _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialDropdownValue.isNotEmpty
        ? widget.initialDropdownValue
        : (widget.itemsValue.isNotEmpty ? widget.itemsValue.first : '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownMenu<String>(
      controller: widget.controller, // Thêm controller vào DropdownMenu
      inputDecorationTheme: InputDecorationTheme(
          // Sử dụng InputDecorationTheme để thiết lập border
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.circular(44)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: stroke),
              borderRadius: BorderRadius.circular(44))),

      textStyle: TextStyle(
        fontFamily: 'ReadexPro',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      trailingIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: text,
      ),
      selectedTrailingIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: primary,
      ),
      initialSelection: dropdownValue,
      onSelected: widget.readOnly
          ? null
          : (String? value) {
              setState(() {
                dropdownValue = value!;
                widget.controller.text = value;
              });
            },
      dropdownMenuEntries:
          widget.itemsValue.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
          style: MenuItemButton.styleFrom(
            foregroundColor: text,
            textStyle: TextStyle(
              fontFamily: 'ReadexPro',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}
