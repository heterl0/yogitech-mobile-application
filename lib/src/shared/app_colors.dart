import 'package:flutter/material.dart';

const Color darkbg = Color(0xFF0a141c); // Màu nền tối
const Color lightbg = Color(0xFFFFFFFF); // Màu nền sáng
const Color elevationDark = Color(0xFF0d1f29); // Màu độ cao tối
const Color elevationLight = Color(0xFFf4f4f4); // Màu độ cao sáng
const Color primary = Color(0xFF4095d0); // Màu chính
const Color text = Color(0xFF8d8e99); // Màu văn bản
const Color active = Color(0xFFFFFFFF); // Màu hoạt động
const Color baseColor = Color(0xFFa4b8be);
Color stroke = baseColor.withOpacity(0.5); // Màu viền với độ mờ 50%
const Color error = Color(0xFFff5858); // Màu lỗi
const LinearGradient gradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF3be2b0),
    Color(0xFF4095d0),
    Color(0xFF5986cc),
  ],
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primary,
  scaffoldBackgroundColor: lightbg, // Đã sử dụng lightbg cho light mode
  backgroundColor: lightbg,
  textTheme: TextTheme(
    bodyText1: TextStyle(color: text),
    bodyText2: TextStyle(color: text),
  ),
  colorScheme: lightColorScheme,
  hintColor: text,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primary,
  scaffoldBackgroundColor: darkbg, // Đã sử dụng darkbg cho dark mode
  backgroundColor: darkbg,
  textTheme: TextTheme(
    bodyText1: TextStyle(color: text),
    bodyText2: TextStyle(color: text),
  ),
  colorScheme: darkColorScheme,
  hintColor: text,
);

final ColorScheme lightColorScheme = ColorScheme.light(
  primary: darkbg,
  onPrimary: darkbg,
  secondary: stroke,
  onSecondary: darkbg,
  error: error,
  background: lightbg,
  surface: elevationLight,
);

final ColorScheme darkColorScheme = ColorScheme.dark(
  primary: active,
  onPrimary: active,
  secondary: stroke,
  onSecondary: active,
  error: error,
  background: darkbg,
  surface: darkbg,
);
