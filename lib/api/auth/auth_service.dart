import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/user.dart';
import 'package:yogi_application/src/services/api_service.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<UserModel?> login(String email, String password) async {
  try {
    final url = formatApiUrl('/api/v1/auth/login/');
    final data = {'email': email, 'password': password};
    Response response = await DioInstance.post(url, data: data);

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

Future<UserModel?> loginGoogle(String authToken) async {
  try {
    final url = formatApiUrl('/api/v1/auth/google/');
    final data = {'auth_token': authToken};
    Response response = await DioInstance.post(url, data: data);
    print(response.data);
    if (response.statusCode == 200) {
      final tokens = response.data['tokens'];
      final accessToken = tokens['access'];
      final refreshToken = tokens['refresh'];
      await saveTokens(accessToken, refreshToken);
      await getToken();

      return UserModel(
          email: '', accessToken: accessToken, refreshToken: refreshToken);
    } else {
      print('Login failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Login error: $e');
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
