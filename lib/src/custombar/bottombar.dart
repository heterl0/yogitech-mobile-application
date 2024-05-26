import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Widget> body = const [Icon(Icons.grid_view)];

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
