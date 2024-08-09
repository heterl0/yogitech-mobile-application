import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/src/pages/activities.dart';
import 'package:YogiTech/src/pages/blog.dart';
import 'package:YogiTech/src/pages/homepage.dart';
import 'package:YogiTech/src/pages/meditate.dart';
import 'package:YogiTech/src/pages/profile.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/shared/styles.dart';

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale locale;
  final ValueChanged<bool> onLanguageChanged;
  final bool isVietnamese;

  const MainScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.locale,
    required this.onLanguageChanged,
    required this.isVietnamese,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Account? _account;

  @override
  void initState() {
    super.initState();
    _fetchAccount();
  }

  Future<void> _fetchAccount() async {
    final Account? account = await retrieveAccount();

    setState(() {
      _account = account;
    });

    // Print the account after it's set
    print(_account);
  }

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!; // Bản dịch
    final theme = Theme.of(context);
    return PersistentTabView(
      navBarHeight: 100,
      backgroundColor: theme.colorScheme.onSecondary,
      tabs: [
        PersistentTabConfig(
          screen: HomePage(
            account: _account,
            fetchAccount: _fetchAccount,
          ),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.grid_view),
            title: trans.home,
            activeForegroundColor:
                (!(_account?.is_premium ?? false)) ? primary : primary2,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Blog(
            account: _account,
          ),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.newspaper_outlined),
            title: trans.blog,
            activeForegroundColor:
                (!(_account?.is_premium ?? false)) ? primary : primary2,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Activities(
            account: _account,
            fetchAccount: _fetchAccount,
          ),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.celebration),
            title: trans.event,
            activeForegroundColor:
                (!(_account?.is_premium ?? false)) ? primary : primary2,
            inactiveForegroundColor: text,
          ),
        ),
        PersistentTabConfig(
          screen: Meditate(),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.self_improvement),
            title: trans.meditate,
            activeForegroundColor:
                (!(_account?.is_premium ?? false)) ? primary : primary2,
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
            account: _account,
            fetchAccount: _fetchAccount,
          ),
          item: ItemConfig(
            textStyle: min_cap,
            icon: const Icon(Icons.account_circle_outlined),
            title: trans.profile,
            activeForegroundColor:
                (!(_account?.is_premium ?? false)) ? primary : primary2,
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
