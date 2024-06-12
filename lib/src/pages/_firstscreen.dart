import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/src/pages/activities.dart';
import 'package:yogi_application/src/pages/blog.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:yogi_application/src/pages/meditate.dart';
import 'package:yogi_application/src/pages/profile.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

class PersistenBottomNavBarDemo extends StatefulWidget {
  final String? savedEmail;
  final String? savedPassword;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const PersistenBottomNavBarDemo({
    Key? key,
    this.savedEmail,
    this.savedPassword,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  _PersistenBottomNavBarDemoState createState() =>
      _PersistenBottomNavBarDemoState();
}

class _PersistenBottomNavBarDemoState extends State<PersistenBottomNavBarDemo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PersistentTabView(
      navBarHeight: 100,
      backgroundColor: theme.colorScheme.onSecondary,
      tabs: [
        PersistentTabConfig(
          screen: HomePage(
              savedEmail: widget.savedEmail,
              savedPassword: widget.savedPassword),
          item: ItemConfig(
            textStyle: min_cap,
            icon: Icon(Icons.grid_view),
            title: "Home",
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Blog(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: Icon(Icons.newspaper_outlined),
            title: "Blog",
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Activities(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: Icon(Icons.directions_run),
            title: "Activities",
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Meditate(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: Icon(Icons.self_improvement),
            title: "Meditate",
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(
              isDarkMode: widget.isDarkMode,
              onThemeChanged: widget.onThemeChanged),
          item: ItemConfig(
            textStyle: min_cap,
            icon: Icon(Icons.account_circle_outlined),
            title: "Profile",
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarDecoration: NavBarDecoration(
            padding: EdgeInsets.only(bottom: 32, top: 12),
            color: theme.colorScheme.onSecondary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        navBarConfig: navBarConfig,
      ),
    );
  }
}
