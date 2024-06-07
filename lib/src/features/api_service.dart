import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:yogi_application/src/models/user_models.dart';
import 'package:yogi_application/src/models/user_models.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  var dio = Dio();

  Future<UserModel?> login(String email, String password) async {
    try {
      final api = '$baseUrl/api/v1/auth/login/';
      final data = {'email': email, 'password': password};
      Response response = await dio.post(api, data: data);
      if (response.statusCode == 200) {
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];
        await saveTokens(accessToken, refreshToken);
        await getToken();

        return UserModel(
            email: email, accessToken: accessToken, refreshToken: refreshToken);
      } else {
        print('Login failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}

Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('refreshToken');
  await prefs.remove('accessToken');
}

Future<Map<String, String?>> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final refreshToken = prefs.getString('refreshToken');
  print('get access token: $accessToken');
  print('get refresh token: $refreshToken');
  return {'access': accessToken, 'refresh': refreshToken};
}

Future<dynamic> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('refreshToken', refreshToken);
  await prefs.setString('accessToken', accessToken);
  // Kiểm tra xem tokens đã được lưu đúng chưa
  final savedAccessToken = prefs.getString('accessToken');
  final savedRefreshToken = prefs.getString('refreshToken');
  print('Saved access token: $savedAccessToken');
  print('Saved refresh token: $savedRefreshToken');
}
