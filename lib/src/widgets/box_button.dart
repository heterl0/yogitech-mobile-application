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
    Key? key,
    required this.title,
    required this.style,
    this.state = ButtonState.Enabled,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = state == ButtonState.Disabled;
    final bool isPressed = state == ButtonState.Pressed;

    // Định nghĩa màu nền dựa trên style và state
    Color getBackgroundColor() {
      switch (style) {
        case ButtonStyleType.Primary:
          return primary;
        case ButtonStyleType.Secondary:
          return elevationLight;
        case ButtonStyleType.Tertiary:
          return baseColor;
      }
    }

    LinearGradient? getBackgroundGradient() {
      if (isDisabled || style != ButtonStyleType.Primary) return null;
      return gradient;
    }

    Color getTextColor() {
      switch (style) {
        case ButtonStyleType.Primary:
          return active;
        case ButtonStyleType.Secondary:
          return primary;
        case ButtonStyleType.Tertiary:
          return isPressed ? active : primary;
      }
    }

    // Định nghĩa viền (outline) cho nút với kích thước 2
    Border? getButtonBorder() {
      if (style == ButtonStyleType.Secondary) {
        if (isPressed || isDisabled) {
          return Border.all(color: primary, width: 2);
        } else {
          return Border.all(color: primary, width: 2);
        }
      } else if (style == ButtonStyleType.Primary) {
        return isPressed ? Border.all(color: text, width: 2) : null;
      }
      return null;
    }

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Opacity(
        opacity: isDisabled ? 0.3 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: double.infinity,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: getBackgroundGradient(),
            color: getBackgroundColor(),
            borderRadius: BorderRadius.circular(44),
            border: getButtonBorder(),
          ),
          child: Text(
            title,
            style: h3.copyWith(
              color: getTextColor(),
            ),
          ),
        ),
      ),
    );
  }
}
