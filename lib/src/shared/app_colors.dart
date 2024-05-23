import 'package:flutter/material.dart';

const Color darkbg = Color(0xFF0a141c); // Màu nền tối
const Color lightbg = Color(0xFFFFFFFF); // Màu nền sáng
const Color elevationDark = Color(0xFF0d1f29); // Màu độ cao tối
const Color elevationLight = Color(0xFFf4f4f4); // Màu độ cao sáng
const Color primary = Color(0xFF4095d0); // Màu chính
const Color text = Color(0xFF8d8e99); // Màu văn bản
const Color active = Color(0xFFFFFFFF); // Màu hoạt động (giống như lightbg)
const Color baseColor = Color(0xFFa4b8be);
Color stroke = baseColor.withOpacity(0.5); // Màu viền với độ mờ 50%
const Color error = Color(0xFFff5858); // Màu lỗi
const LinearGradient gradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF3be2b0),
    Color(0xFF4095d0),
    Color(0xFF5986cc),
  ],
);
