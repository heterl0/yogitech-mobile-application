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
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      child: BottomAppBar(
        color: theme.colorScheme.onSecondary,
        height: 90,
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavItem(
                  context, Icons.grid_view, 'Home', AppRoutes.homepage),
              buildNavItem(
                  context, Icons.newspaper_outlined, 'Blog', AppRoutes.login),
              buildNavItem(context, Icons.directions_run, 'Activities',
                  AppRoutes.activities),
              buildNavItem(context, Icons.self_improvement, 'Meditate',
                  AppRoutes.meditate),
              buildNavItem(context, Icons.account_circle_outlined,
                  AppRoutes.Profile, 'profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(
      BuildContext context, IconData icon, String label, String routeName) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        borderRadius: BorderRadius.circular(44.0),
        child: Container(
          height: 60.0, // Chiều cao của mỗi item trong hàng
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(44.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: text), // Icon
                const SizedBox(height: 4), // Khoảng cách giữa icon và label
                Text(
                  label,
                  style: min_cap.copyWith(color: text),
                ), // Label
              ],
            ),
          ),
        ),
      ),
    );
  }
}
