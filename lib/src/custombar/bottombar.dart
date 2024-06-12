import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/box_button.dart';

class CustomBottomBar extends StatefulWidget {
  final String buttonTitle;
  final VoidCallback? onPressed;

  const CustomBottomBar({
    Key? key,
    this.buttonTitle = '',
    this.onPressed,
  }) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      child: BottomAppBar(
          elevation: appElevation,
          color: theme.colorScheme.onSecondary,
          height: 100,
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: BoxButton(
                title: widget.buttonTitle,
                style: ButtonStyleType.Primary,
                onPressed: widget.onPressed,
              ),
            ),
          )),
    );
  }
}
