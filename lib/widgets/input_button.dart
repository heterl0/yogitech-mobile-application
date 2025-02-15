import 'package:YogiTech/widgets/box_button_v2.dart';
import 'package:YogiTech/widgets/box_input_field_v2.dart';
import 'package:flutter/material.dart';
import 'package:YogiTech/shared/app_colors.dart'; // Import your color definitions
import 'package:YogiTech/shared/styles.dart'; // Import your text styles

class CustomInputButton extends StatefulWidget {
  final String title;
  final String? subtitle; // Make subtitle nullable
  final int value;
  final ValueChanged<int>? onChanged;
  final bool enabled; // Add enabled property

  const CustomInputButton({
    super.key,
    required this.title,
    this.subtitle, // Make subtitle nullable
    required this.value,
    this.onChanged,
    this.enabled = true, // Set default value to true
  });

  @override
  _CustomInputButtonState createState() => _CustomInputButtonState();
}

class _CustomInputButtonState extends State<CustomInputButton> {
  int _value = 10;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController delayController = TextEditingController();
    delayController.value = TextEditingValue(text: _value.toString());
    return Column(
      children: [
        Opacity(
            opacity: widget.enabled
                ? 1.0
                : 0.5, // Set opacity based on widget enabled property
            child: ListTile(
              enabled: widget.enabled, // Set ListTile enabled property
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.subtitle != null) // Check if subtitle exists
                    Text(
                      widget.title,
                      style: h2.copyWith(
                          color: theme.colorScheme.onPrimary, height: 1),
                    ),
                  if (widget.subtitle != null) // Check if subtitle exists
                    Text(
                      widget.subtitle!, // Display subtitle if exists
                      style:
                          bd_text.copyWith(color: text), // Style for subtitle
                    ),
                  if (widget.subtitle ==
                      null) // Check if subtitle doesn't exist
                    Text(
                      widget.title, // Display title if no subtitle
                      style: h3.copyWith(color: text, height: 1),
                    ),
                ],
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButtonV2(
              title: "-",
              style: ButtonStyleType.Primary,
              state: _value < 10 ? ButtonState.Disabled : ButtonState.Enabled,
              onPressed: () {
                if (_value >= 10) {
                  setState(() {
                    _value = _value - 5;
                    delayController.text = _value.toString();
                    if (widget.onChanged != null) {
                      widget.onChanged!(_value);
                    }
                  });
                }
              },
            ),
            SizedBox(width: 8.0),
            BoxInputFieldV2(
              controller: delayController,
              keyboardType: TextInputType.number,
              readOnly: true,
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(int.parse(value));
                }
              },
            ),
            SizedBox(width: 8.0),
            CustomButtonV2(
              title: "+",
              style: ButtonStyleType.Primary,
              state: _value > 25 ? ButtonState.Disabled : ButtonState.Enabled,
              onPressed: () {
                if (_value <= 95) {
                  setState(() {
                    _value = _value + 5;
                    delayController.text = _value.toString();
                    if (widget.onChanged != null) {
                      widget.onChanged!(_value);
                    }
                  });
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
