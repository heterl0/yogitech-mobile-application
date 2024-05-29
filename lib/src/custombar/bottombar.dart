import 'package:flutter/material.dart';
import 'package:yogi_application/src/routing/app_routes.dart';

class CustomBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
      child: BottomAppBar(
        color: Color(0xFF0D1F29),
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
                Navigator.pushNamed(context, '/blog');
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.newspaper_outlined, 'Blog'),
            ),
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Activities
                Navigator.pushNamed(context, '/activities');
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.notifications, 'Activities'),
            ),
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Metitate
                Navigator.pushNamed(context, '/metitate');
              },
              borderRadius: BorderRadius.circular(44.0),
              child: buildNavItem(Icons.account_circle, 'Metitate'),
            ),
            InkWell(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào nút Profile
                Navigator.pushNamed(context, '/profile');
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
            Icon(icon, color: Colors.white), // Icon
            SizedBox(height: 4), // Khoảng cách giữa icon và label
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ), // Label
          ],
        ),
      ),
    );
  }
}
