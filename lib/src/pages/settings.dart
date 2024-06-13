import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:yogi_application/src/custombar/appbar.dart';
import 'package:yogi_application/src/pages/notifications.dart';
import 'package:yogi_application/src/pages/reminder.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/widgets/switch.dart';
import 'package:yogi_application/src/pages/change_profile.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Locale locale;
  final ValueChanged<bool> onLanguageChanged;

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.locale,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isVi = locale.languageCode == 'vi';
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: "Setting",
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSwitch(
                title: 'Dark mode',
                value: isDarkMode,
                onChanged: onThemeChanged,
              ),
              CustomSwitch(
                title: 'Vietnamese UI?',
                value: isVi,
                onChanged: onLanguageChanged,
              ),
              SettingItem(
                title: 'Profile',
                description: 'Your information, avatar, and BMI',
                icon: Icons.account_circle_outlined, // Biểu tượng cho mục này
                onTap: () {
                  pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeProfilePage(),
                    ),
                  );
                },
              ),
              SettingItem(
                title: 'Reminder',
                description: 'Reminds you of exercise time',
                icon: Icons.alarm, // Biểu tượng cho mục này
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
                title: 'Notifications',
                description: 'Application notifications',
                icon: Icons
                    .notifications_active_outlined, // Biểu tượng cho mục này
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsPage(),
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
  final VoidCallback? onTap; // Thêm thuộc tính onTap

  const SettingItem({
    Key? key,
    this.title,
    this.description,
    this.icon,
    this.onTap, // Thêm onTap vào constructor
  }) : super(key: key);

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
            // Thêm Material để đảm bảo hiệu ứng ripple hoạt động đúng
            color: Colors.transparent,
            child: InkWell(
                onTap: onTap,
                borderRadius:
                    BorderRadius.circular(16), // Thêm borderRadius cho InkWell
                child: Padding(
                  // Dùng Padding thay vì margin & padding riêng biệt
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
                            return gradient
                                .createShader(bounds); // Tạo shader từ gradient
                          },
                          child: Icon(
                            icon, // Sử dụng IconData được truyền vào từ bên ngoài
                            color: Colors.white,
                            size:
                                36, // Màu icon không quan trọng vì sẽ được thay thế bởi gradient
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
                            Text('${description ?? 'N/A'}',
                                style: min_cap.copyWith(color: text)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
