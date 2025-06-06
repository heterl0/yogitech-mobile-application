import 'package:flutter/material.dart';
import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:ZenAiYoga/shared/styles.dart';

// Enum to represent more descriptive checkbox states
enum CheckState { Checked, Unchecked }

class CheckBoxListTile extends StatefulWidget {
  final String title;
  final String subtitle; // Added subtitle
  final CheckState state;
  final TextStyle? customTextStyle;
  final ValueChanged<bool>? onChanged; // Use ValueChanged for state updates

  const CheckBoxListTile({
    super.key,
    this.title = '',
    this.subtitle = '', // Added subtitle
    this.state = CheckState.Unchecked,
    this.onChanged,
    this.customTextStyle,
  });

  @override
  _CheckBoxListTileState createState() => _CheckBoxListTileState();
}

class _CheckBoxListTileState extends State<CheckBoxListTile> {
  bool _isChecked = false; // Internal state for checkbox value

  @override
  void initState() {
    super.initState();
    _isChecked = widget.state == CheckState.Checked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: widget.title.isNotEmpty
          ? Text(
              widget.title,
              style: widget.customTextStyle ??
                  h3.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
            )
          : null,
      subtitle: widget.subtitle.isNotEmpty
          ? Text(
              widget.subtitle,
              style: min_cap.copyWith(color: text),
            )
          : null,
      leading: Checkbox(
        value: _isChecked,
        onChanged: (value) {
          setState(() {
            _isChecked = value!;
            widget.onChanged
                ?.call(value); // Notify parent widget of state change
          });
        },
        fillColor: WidgetStateColor.resolveWith((states) {
          final ThemeData theme = Theme.of(context);
          return theme.brightness == Brightness.light
              ? elevationLight
              : elevationDark;
        }),

        checkColor: primary, // Color of the checkmark
        materialTapTargetSize:
            MaterialTapTargetSize.shrinkWrap, // Prevent button-like behavior
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ), // Square checkbox
        side: BorderSide(
          color: stroke,
          width: 1,
        ), // Custom border color
      ),
    );
  }
}
