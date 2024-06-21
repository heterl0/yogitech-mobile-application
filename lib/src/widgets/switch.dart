import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart'; // Import your color definitions
import 'package:yogi_application/src/shared/styles.dart'; // Import your text styles

class CustomSwitch extends StatefulWidget {
  final String title;
  final String? subtitle; // Make subtitle nullable
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled; // Add enabled property

  const CustomSwitch({
    super.key,
    required this.title,
    this.subtitle, // Make subtitle nullable
    required this.value,
    this.onChanged,
    this.enabled = true, // Set default value to true
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
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
                style:
                    h2.copyWith(color: theme.colorScheme.onPrimary, height: 1),
              ),
            if (widget.subtitle != null) // Check if subtitle exists
              Text(
                widget.subtitle!, // Display subtitle if exists
                style: bd_text.copyWith(color: text), // Style for subtitle
              ),
            if (widget.subtitle == null) // Check if subtitle doesn't exist
              Text(
                widget.title, // Display title if no subtitle
                style: h3.copyWith(color: text, height: 1),
              ),
          ],
        ),
        trailing: Switch(
          value: _isOn,
          onChanged: widget.enabled // Check if widget is enabled
              ? (value) {
                  setState(() {
                    _isOn = value;
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  });
                }
              : null, // Set onChanged to null if widget is disabled
          activeColor: theme.brightness == Brightness.light
              ? elevationLight
              : elevationDark,
          activeTrackColor: primary,
          inactiveThumbColor: theme.scaffoldBackgroundColor,
          inactiveTrackColor: text,
          trackOutlineColor: WidgetStateColor.resolveWith(
              (states) => theme.scaffoldBackgroundColor),
        ),
      ),
    );
  }
}
