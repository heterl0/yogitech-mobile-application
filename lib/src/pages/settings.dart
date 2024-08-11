import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/src/pages/exercise_settings.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:YogiTech/src/custombar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:YogiTech/src/pages/notifications.dart';
import 'package:YogiTech/src/pages/reminder.dart';
import 'package:YogiTech/src/shared/styles.dart';
import 'package:YogiTech/src/shared/app_colors.dart';
import 'package:YogiTech/src/widgets/switch.dart';
import 'package:YogiTech/src/pages/change_profile.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale locale;
  final bool isVietnamese;
  final ValueChanged<bool> onLanguageChanged;
  final VoidCallback? onProfileUpdated;
  final Account? account;

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.locale,
    required this.onLanguageChanged,
    required this.isVietnamese,
    this.onProfileUpdated,
    this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trans = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: trans.setting,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSwitch(
                title: trans.darkMode,
                value: isDarkMode,
                onChanged: onThemeChanged,
              ),
              CustomSwitch(
                title: trans.vietnameseUI,
                value: isVietnamese,
                onChanged: onLanguageChanged,
              ),
              SettingItem(
                title: trans.profile,
                description: trans.yourInfo,
                icon: Icons.account_circle_outlined,
                onTap: () {
                  pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeProfilePage(
                        onProfileUpdated: onProfileUpdated,
                        account: account,
                      ),
                    ),
                  );
                },
              ),
              SettingItem(
                title: trans.reminder,
                description: trans.exerciseReminder,
                icon: Icons.alarm,
                onTap: () {
                  pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReminderPage(),
                    ),
                  );
                },
              ),
              SettingItem(
                title: trans.notifications,
                description: trans.appNotifications,
                icon: Icons.notifications_active_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(),
                    ),
                  );
                },
              ),
              SettingItem(
                title: trans.exerciseSetting,
                description: trans.exerciseSettingDescription,
                icon: Icons.settings_accessibility,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseSettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String? title;
  final String? description;
  final IconData? icon;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    this.title,
    this.description,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return gradient.createShader(bounds);
                    },
                    child: Icon(
                      icon,
                      color: active,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title ?? 'N/A',
                          style: bd_text.copyWith(
                              color: theme.colorScheme.onPrimary)),
                      const SizedBox(height: 4),
                      Text(description ?? 'N/A',
                          style: min_cap.copyWith(color: text)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
