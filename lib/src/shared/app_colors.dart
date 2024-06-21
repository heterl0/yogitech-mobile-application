import 'package:flutter/material.dart';

// Base colors
const Color darkbg = Color(0xFF0a141c); // Màu nền tối
const Color lightbg = Color(0xFFFFFFFF); // Màu nền sáng

// Text colors
const Color text = Color(0xFF8d8e99); // Màu văn bản
const Color active = Color(0xFFFFFFFF); // Màu hoạt động

const Color elevationDark = Color(0xFF0d1f29); // Màu độ cao tối
const Color elevationLight = Color(0xFFf4f4f4); // Màu độ cao sáng

// Other colors
const Color primary = Color(0xFF4095d0); // Màu chính
const Color green = Color(0xFF3BE2B0);
const Color error = Color(0xFFff5858); // Màu lỗi

// Derived colors
Color stroke = Color(0xFFa4b8be).withOpacity(0.5); // Màu viền với độ mờ 50%

// Theme colors (light and dark)
const LinearGradient gradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF3be2b0),
    Color(0xFF4095d0),
    Color(0xFF5986cc),
  ],
);

final ColorScheme lightColorScheme = ColorScheme.light(
  primary: primary,
  onPrimary: darkbg,
  secondary: stroke,
  onSecondary: elevationLight,
  error: error,
  background: lightbg,
  surface: elevationLight,
  onBackground: text,
);

final ColorScheme darkColorScheme = ColorScheme.dark(
  primary: primary,
  onPrimary: active,
  secondary: stroke,
  onSecondary: elevationDark,
  error: error,
  background: darkbg,
  surface: elevationDark,
  onBackground: active,
);

// Themes (light and dark)
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primary,
  scaffoldBackgroundColor: lightbg,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: text),
    bodyMedium: TextStyle(color: text),
  ),
  hintColor: text,
  colorScheme: lightColorScheme.copyWith(background: lightbg),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primary,
  scaffoldBackgroundColor: darkbg,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: active),
    bodyMedium: TextStyle(color: text),
  ),
  hintColor: text,
  colorScheme: darkColorScheme.copyWith(background: darkbg),
);

// Function to get custom color based on theme
Color getCustomColor(BuildContext context) {
  return Theme.of(context).colorScheme.onBackground;
}
