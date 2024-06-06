import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  var dio = Dio();

  Future<dynamic> Login(String email, String password) async {
    try {
      final api = baseUrl + '/api/v1/auth/login/';
      final data = {'email': email, 'password': password};
      Response response = await dio.post(api, data: data);
      print('POST Response: ${response.data}');

      if (response.statusCode == 200) {
        print(response.statusCode);
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];
        await saveTokens(accessToken, refreshToken);
        print(response.data['access']);
        print(response.data['refresh']);
      } else {
        print('failed');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<dynamic> register(
  //     String username, String email, String password, String rePassword) async {
  //   final response = await http.post(
  //     Uri.parse('${baseUrl}/api/v1/users/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'username': username,
  //       'email': email,
  //       'password': password,
  //       're_password': rePassword,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to register');
  //   }
  // }
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

Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('refreshToken');
  await prefs.remove('accessToken');
}

Future<dynamic> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('refreshToken', refreshToken);
  await prefs.setString('accessToken', accessToken);
}
