import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/src/models/account.dart';
import 'package:YogiTech/utils/formatting.dart';

Future<dynamic> login(String email, String password) async {
  try {
    final url = formatApiUrl('/api/v1/auth/login/');
    final data = {'email': email, 'password': password};
    Response response = await DioInstance.post(url, data: data);
    if (response.statusCode == 200) {
      final accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];
      await saveTokens(accessToken, refreshToken);
      DioInstance.setAccessToken(accessToken);
      Account? account = await getUser();
      storeAccount(account!);
      return accessToken;
    } else {
      print('Login failed with status code: ${response.statusCode}');
      return {'status': response.statusCode, 'message': response.data};
    }
  } catch (e) {
    if (e is DioException) {
      return {'status': e.response!.statusCode, 'message': e.response!.data};
    }
  }
}

class RegisterRequest {
  String email;
  String password;
  String username;
  String re_password;

  RegisterRequest(
      {required this.email,
      required this.password,
      required this.username,
      required this.re_password});
}

Future<dynamic> register(RegisterRequest data) async {
  try {
    final url = formatApiUrl('/api/v1/users/');
    final bodyData = {
      'email': data.email,
      'password': data.password,
      'username': data.username,
      're_password': data.re_password
    };
    Response response = await DioInstance.post(url, data: bodyData);

    if (response.statusCode == 201) {
      return {'status': response.statusCode, 'message': response.data};
    }
  } catch (e) {
    if (e is DioException) {
      return {'status': e.response!.statusCode, 'message': e.response!.data};
    }
    print('Register error: $e');
  }
}

Future<dynamic> loginGoogle(String authToken) async {
  try {
    final url = formatApiUrl('/api/v1/auth/google/');
    final data = {'auth_token': authToken};
    Response response = await DioInstance.post(url, data: data);
    if (response.statusCode == 200) {
      final tokens = response.data['tokens'];
      final accessToken = tokens['access'];
      final refreshToken = tokens['refresh'];
      await saveTokens(accessToken, refreshToken);
      DioInstance.setAccessToken(accessToken);
      Account? account = await getUser();
      storeAccount(account!);
      return accessToken;
    } else {
      print('Login failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    if (e is DioException) {
      print({'status': e.response!.statusCode, 'message': e.response!.data});
      return null;
    }
    return null;
  }
}

Future<String?> updateAccessToken(String refreshToken) async {
  try {
    final url = formatApiUrl('/api/v1/auth/refresh/');
    final data = {'refresh': refreshToken};
    final Response response = await DioInstance.post(url, data: data);

    if (response.statusCode == 200) {
      final newAccessToken = response.data['access'];
      await saveTokens(newAccessToken, refreshToken);
      await getToken();
      return newAccessToken;
    } else {
      print('Failed to update access token: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error updating access token: $e');
    return null;
  }
}

Future<bool> verifyToken(String? accessToken) async {
  try {
    final url = formatApiUrl('/api/v1/auth/verify/');
    final data = {'token': accessToken};
    final Response response = await DioInstance.post(url, data: data);
    return response.statusCode == 200;
  } catch (e) {
    print('Error updating access token: $e');
    return false;
  }
}

Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('refreshToken');
  await prefs.remove('accessToken');
}

Future<Map<String?, String?>> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final refreshToken = prefs.getString('refreshToken');
  if (accessToken != null) {
    if (await verifyToken(accessToken)) {
      return {'access': accessToken, 'refresh': refreshToken};
    } else {
      if (refreshToken != null) {
        final newAccessToken = await updateAccessToken(refreshToken);
        if (newAccessToken != null) {
          return {'access': newAccessToken, 'refresh': refreshToken};
        } else {
          await clearToken();
          return {'access': null, 'refresh': null};
        }
      } else {
        await clearToken();
        return {'access': null, 'refresh': null};
      }
    }
  }
  return {'access': null, 'refresh': null};
}

Future<dynamic> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('refreshToken', refreshToken);
  await prefs.setString('accessToken', accessToken);
  // Kiểm tra xem tokens đã được lưu đúng chưa
}

Future<void> storeAccount(Account account) async {
  final prefs = await SharedPreferences.getInstance();
  final accountJson = jsonEncode(account.toMap());
  await prefs.setString("_accountKey", accountJson);
}

Future<Account?> retrieveAccount() async {
  final prefs = await SharedPreferences.getInstance();
  final accountJson = prefs.getString("_accountKey");
  if (accountJson != null) {
    final accountMap = jsonDecode(accountJson);
    return Account.fromMap(accountMap);
  } else {
    return null;
  }
}

Future<void> clearAccount() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('_accountKey');
}
