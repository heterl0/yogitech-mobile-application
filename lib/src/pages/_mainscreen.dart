import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/src/pages/activities.dart';
import 'package:yogi_application/src/pages/blog.dart';
import 'package:yogi_application/src/pages/homepage.dart';
import 'package:yogi_application/src/pages/meditate.dart';
import 'package:yogi_application/src/pages/profile.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/shared/styles.dart';

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale locale;
  final ValueChanged<bool> onLanguageChanged;
  final bool isVietnamese;

  const MainScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.locale,
    required this.onLanguageChanged,
    required this.isVietnamese,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!; // Bản dịch
    final theme = Theme.of(context);
    return PersistentTabView(
      navBarHeight: 100,
      backgroundColor: theme.colorScheme.onSecondary,
      tabs: [
        PersistentTabConfig(
          screen: HomePage(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.grid_view),
            title: trans.home,
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Blog(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.newspaper_outlined),
            title: trans.blog,
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Activities(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.directions_run),
            title: trans.activities,
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Meditate(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.self_improvement),
            title: trans.meditate,
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: ProfilePage(
            isVietnamese: widget.isVietnamese,
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
            locale: widget.locale,
            onLanguageChanged: widget.onLanguageChanged,
          ),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.account_circle_outlined),
            title: trans.profile,
            activeForegroundColor: primary,
            inactiveForegroundColor: text,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarDecoration: NavBarDecoration(
            padding: const EdgeInsets.only(bottom: 32, top: 12),
            color: theme.colorScheme.onSecondary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        navBarConfig: navBarConfig,
      ),
    );
  }
}
