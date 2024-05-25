import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

// Enum to represent more descriptive checkbox states
enum CheckState { Checked, Unchecked }

class CheckBox extends StatefulWidget {
  final String title;
  final CheckState state;
  final ValueChanged<bool>? onChanged; // Use ValueChanged for state updates
  final Color? borderColor; // Custom border color
  final Color? checkColor; // Custom checkmark color

  const CheckBox({
    Key? key,
    required this.title,
    this.state = CheckState.Unchecked,
    this.onChanged,
    this.borderColor,
    this.checkColor,
  }) : super(key: key);

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _isChecked = false; // Internal state for checkbox value

  @override
  void initState() {
    super.initState();
    _isChecked = widget.state == CheckState.Checked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Checkbox(
      value: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value!;
          widget.onChanged?.call(value); // Notify parent widget of state change
        });
      },
      activeColor: theme.primaryColor, // Use theme's primary color
      checkColor: widget.checkColor ??
          theme.colorScheme.onPrimary, // Color of the checkmark
      materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap, // Prevent button-like behavior
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)) // Square checkbox
      , // Rounded checkbox
      side: BorderSide(
          color: widget.borderColor ?? theme.primaryColor,
          width: 2), // Custom border color
    );
  }
}
