import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  var dio = Dio();

  // Future<dynamic> login(String email, String password) async {
  //   var account;
  //   var response = await dio.post(
  //     Uri.parse('${baseUrl}/api/v1/auth/login/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to log in');
  //   }
  // }
  Future<dynamic> login(String email, String password) async {
    var dio = Dio();
    try {
      final response = await dio.post(
        'http://192.168.10.121:8000/api/v1/auth/login/', // Thay bằng endpoint API của bạn
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Xử lý phản hồi khi đăng nhập thành công
        print('Đăng nhập thành công!');
        print('Email: ${response.data['email']}');
        print('Password: ${response.data['password']}');
      } else {
        // Xử lý khi đăng nhập không thành công
        print('Đăng nhập thất bại: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        // Xử lý lỗi khi nhận được phản hồi từ máy chủ
        print('DioError: ${e.response?.statusCode}');
        print('DioError: ${e.response?.data}');
      } else {
        // Xử lý lỗi khi không nhận được phản hồi từ máy chủ
        print('Lỗi khi gửi yêu cầu!');
        print(e.message);
      }
    }
  }

  Future<dynamic> register(
      String username, String email, String password, String rePassword) async {
    final response = await http.post(
      Uri.parse('${baseUrl}/api/v1/users/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        're_password': rePassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }
}

Future<void> saveLoginInfo(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', password);
}

Future<Map<String, String?>> getLoginInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final password = prefs.getString('password');
  return {'email': email, 'password': password};
}

Future<void> clearLoginInfo() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
  await prefs.remove('password');
}
