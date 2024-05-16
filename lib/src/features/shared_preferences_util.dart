import 'package:flutter/material.dart';
import 'package:yogi_application/src/features/shared_preferences_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginInfo(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', password);
}

Future<Map<String, String?>> getLoginInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email') ?? ''; // Sử dụng '' nếu giá trị null
  final password =
      prefs.getString('password') ?? ''; // Sử dụng '' nếu giá trị null
  return {'email': email, 'password': password};
}

Future<void> clearLoginInfo() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
  await prefs.remove('password');
}
