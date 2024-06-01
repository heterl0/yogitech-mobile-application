import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart'; // Import your color definitions
import 'package:yogi_application/src/shared/styles.dart'; // Import your text styles

class CustomSwitch extends StatefulWidget {
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({
    Key? key,
    required this.title,
    required this.value,
    this.onChanged,
  }) : super(key: key);

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

    return ListTile(
      title: Text(
        widget.title,
        style: h3.copyWith(
          color: text,
        ),
      ),
      trailing: Switch(
        value: _isOn,
        onChanged: (value) {
          setState(() {
            _isOn = value;
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          });
        },
        activeColor: theme.brightness == Brightness.light
            ? elevationLight
            : elevationDark,
        activeTrackColor: primary,
        inactiveThumbColor: theme.scaffoldBackgroundColor,
        inactiveTrackColor: text,
        trackOutlineColor: MaterialStateColor.resolveWith(
            (states) => theme.scaffoldBackgroundColor),
      ),
    );
  }
}
