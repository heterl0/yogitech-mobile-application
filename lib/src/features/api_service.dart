import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  get dio => null;

  Future<dynamic> login(String email, String password) async {
    Response response = await dio.post(
      Uri.parse('${baseUrl}/api/v1/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to log in');
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
