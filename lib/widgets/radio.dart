import 'package:flutter/material.dart';
import 'package:ZenAiYoga/shared/app_colors.dart';
import 'package:ZenAiYoga/shared/styles.dart';

class RadioListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final TextStyle? customTextStyle;
  final ValueChanged<bool>? onChanged;

  const RadioListTile({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.isSelected = false,
    this.onChanged,
    this.customTextStyle,
  });

  @override
  _RadioListTileState createState() => _RadioListTileState();
}

class _RadioListTileState extends State<RadioListTile> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
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
      leading: Radio<bool>(
        value: true,
        groupValue: _isSelected,
        onChanged: (value) {
          setState(() {
            _isSelected = value!;
            widget.onChanged?.call(value);
          });
        },
        fillColor: WidgetStateColor.resolveWith((states) {
          final ThemeData theme = Theme.of(context);
          return theme.brightness == Brightness.light
              ? elevationLight
              : elevationDark;
        }),
        activeColor: primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
} 