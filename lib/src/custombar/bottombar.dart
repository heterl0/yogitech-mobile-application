import 'package:flutter/material.dart';
import 'package:yogi_application/src/routing/app_routes.dart';
import 'package:yogi_application/src/shared/styles.dart';
import 'package:yogi_application/src/shared/app_colors.dart';

class CustomBottomBar extends StatefulWidget {
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      child: BottomAppBar(
        color: theme.colorScheme.onSecondary,
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Home
                Navigator.pushNamed(context, AppRoutes.homepage);
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.grid_view, 'Home'),
            ),
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Blog
                Navigator.pushNamed(context, AppRoutes.login);
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.newspaper_outlined, 'Blog'),
            ),
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Activities
                Navigator.pushNamed(context, AppRoutes.paymentHistory);
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.notifications, 'Activities'),
            ),
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Metitate
                Navigator.pushNamed(context, AppRoutes.preLaunchSurvey);
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.account_circle, 'Metitate'),
            ),
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Profile
                Navigator.pushNamed(context, AppRoutes.Profile);
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.account_circle_outlined, 'Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: text), // Icon
            SizedBox(height: 4), // Khoảng cách giữa icon và label
            Text(
              label,
              style: min_cap.copyWith(color: text),
            ), // Label
          ],
        ),
      ),
    );
  }
}
