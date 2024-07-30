import 'package:flutter/material.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';

enum ButtonStyleType { Primary, Secondary, Tertiary, Quaternary }

enum ButtonState { Enabled, Disabled, Pressed }

class CustomButton extends StatelessWidget {
  final String title;
  final ButtonStyleType style;
  final ButtonState state;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.title,
    required this.style,
    this.state = ButtonState.Enabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDisabled = state == ButtonState.Disabled;
    final bool isPressed = state == ButtonState.Pressed;

    // Define background color based on style and state
    Color getBackgroundColor() {
      switch (style) {
        case ButtonStyleType.Primary:
          return theme.primaryColor;
        case ButtonStyleType.Secondary:
          return theme.colorScheme.surface;
        case ButtonStyleType.Tertiary:
          return Colors.transparent;
        case ButtonStyleType.Quaternary:
          return theme.colorScheme.surface;
      }
    }

    LinearGradient? getBackgroundGradient() {
      if (isDisabled || style != ButtonStyleType.Primary) return null;
      return gradient;
    }

    // Define border based on style and state
    Border? getButtonBorder() {
      if (style == ButtonStyleType.Secondary) {
        return Border.all(color: theme.primaryColor, width: 2);
      } else if (style == ButtonStyleType.Primary) {
        return isPressed
            ? Border.all(color: theme.colorScheme.onPrimary, width: 2)
            : null;
      } else if (style == ButtonStyleType.Quaternary) {
        return Border.all(color: error, width: 2); // Add border for Quaternary
      }
      return null;
    }

    Color getTextColor() {
      if (style == ButtonStyleType.Primary) {
        return active; // Use your defined active color for primary buttons
      } else if (style == ButtonStyleType.Quaternary) {
        return error; // Specific color for Quaternary
      } else {
        return primary; // Use your defined gradient color for other styles
      }
    }

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: double.infinity,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: getBackgroundGradient(),
            color: getBackgroundColor(),
            borderRadius: BorderRadius.circular(44),
            border: getButtonBorder(),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(44),
              onTap: isDisabled ? null : onPressed,
              splashColor: style == ButtonStyleType.Primary
                  ? active.withOpacity(0.2)
                  : primary.withOpacity(0.2),
              highlightColor: style == ButtonStyleType.Primary
                  ? active.withOpacity(0.2)
                  : primary.withOpacity(0.2),
              child: Center(
                child: Text(
                  title,
                  style: h3.copyWith(
                    color: getTextColor(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
