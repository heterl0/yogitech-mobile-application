import 'package:flutter/material.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';
import 'package:yogi_application/src/custombar/bottombar.dart';

class ReminderPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ReminderPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: theme.colorScheme.onSecondary,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  right: 24.0,
                  left: 24.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onBackground,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text('Reminder',
                        style:
                            h2.copyWith(color: theme.colorScheme.onBackground)),
                    Opacity(
                      opacity: 0.0,
                      child: IgnorePointer(
                        child: IconButton(
                          icon: Image.asset('assets/icons/settings.png'),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('05:20 AM',
                        style: h2.copyWith(color: theme.colorScheme.onPrimary)),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Add your code to handle editing time
                      },
                    ),
                  ],
                ),
              ),
              const SettingItem(
                title: 'Morning Reminder',
                description: 'Remind you to exercise in the morning',
                icon: Icons.alarm_on,
              ),
              const SettingItem(
                title: 'Afternoon Reminder',
                description: 'Remind you to exercise in the afternoon',
                icon: Icons.alarm_on,
              ),
              const SettingItem(
                title: 'Evening Reminder',
                description: 'Remind you to exercise in the evening',
                icon: Icons.alarm_on,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String? title;
  final String? description;
  final IconData? icon;

  const SettingItem({
    Key? key,
    this.title,
    this.description,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 80,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
      ),
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
                icon ?? Icons.alarm_on,
                color: Colors.white,
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
                    style:
                        bd_text.copyWith(color: theme.colorScheme.onPrimary)),
                const SizedBox(height: 4),
                Text(description ?? 'N/A',
                    style: min_cap.copyWith(color: text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
