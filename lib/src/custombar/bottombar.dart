import 'package:flutter/material.dart';
import 'package:yogi_application/main.dart';
import 'package:yogi_application/main.dart';
import 'package:yogi_application/src/pages/forgot_password.dart';
import 'package:yogi_application/src/pages/login_page.dart';
import 'package:yogi_application/src/pages/reset_password_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  List pages = const [
    HomePage,
    ResetPasswordPage,
    LoginPage,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Text1'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Home2'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Home3'),
          ],
        ),
        body: pages[_currentIndex]);
  }
}
