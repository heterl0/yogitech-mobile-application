import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/styles.dart';

enum widthStyle { Small, Medium, Large }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final String title;
  final bool showBackButton;
  final List<Widget> preActions, postActions;
  final double height;
  final VoidCallback? onBackPressed;
  final widthStyle style;

  CustomAppBar({
    this.titleWidget,
    this.title = '',
    this.showBackButton = true,
    this.preActions = const [],
    this.postActions = const [],
    this.height = 120.0,
    this.onBackPressed,
    this.style = widthStyle.Small,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidth = (style == widthStyle.Large)
        ? 2
        : (style == widthStyle.Small || title == '')
            ? 8
            : 4;

    final theme = Theme.of(context);
    return Container(
      height: preferredSize.height,
      child: AppBar(
        scrolledUnderElevation: appElevation,
        elevation: appElevation,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: iconWidth,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: showBackButton
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: theme.colorScheme.onBackground,
                            ),
                            onPressed: () {
                              if (onBackPressed != null) {
                                onBackPressed!();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: preActions,
                          ),
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: titleWidget ??
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: h2.copyWith(
                              color: theme.colorScheme.onBackground),
                        ),
                  ),
                ),
                Expanded(
                  flex: iconWidth,
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 50,
                    child: () {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: postActions,
                      );
                    }(),
                  ),
                ),
              ],
            )),
        backgroundColor: theme.colorScheme.onSecondary,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
