import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

enum ButtonStyleType { Primary, Secondary, Tertiary }

enum ButtonState { Enabled, Disabled, Pressed }

class BoxButton extends StatelessWidget {
  final String title;
  final ButtonStyleType style;
  final ButtonState state;
  final VoidCallback? onPressed;

  const BoxButton({
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

    // Định nghĩa màu nền dựa trên style và state
    Color getBackgroundColor() {
      switch (style) {
        case ButtonStyleType.Primary:
          return theme.primaryColor;
        case ButtonStyleType.Secondary:
          return theme.colorScheme.surface;
        case ButtonStyleType.Tertiary:
          return Colors.transparent;
      }
    }

    LinearGradient? getBackgroundGradient() {
      if (isDisabled || style != ButtonStyleType.Primary) return null;
      return gradient;
    }

    // Định nghĩa viền (outline) cho nút với kích thước 2
    Border? getButtonBorder() {
      if (style == ButtonStyleType.Secondary) {
        if (isPressed || isDisabled) {
          return Border.all(color: theme.primaryColor, width: 2);
        } else {
          return Border.all(color: theme.primaryColor, width: 2);
        }
      } else if (style == ButtonStyleType.Primary) {
        return isPressed
            ? Border.all(color: theme.colorScheme.onPrimary, width: 2)
            : null;
      }
      return null;
    }

    Color getTextColor() {
      if (style == ButtonStyleType.Primary) {
        return active; // Use your defined active color for primary buttons
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
