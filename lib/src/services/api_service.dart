import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:yogi_application/src/models/user.dart';
import 'package:yogi_application/src/pages/blog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = 'https://api.yogitech.me';

class ApiService {
  String baseUrl = dotenv.get('API_BASE_URL');

  // ApiService() {
  //   // this.baseUrl = dotenv.get('API_BASE_URL');
  // }

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

  Future<UserModel?> loginGoogle(String authToken) async {
    try {
      final api = '$baseUrl/api/v1/auth/google/';
      final data = {'auth_token': authToken};
      Response response = await dio.post(api, data: data);
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
      final api = '$baseUrl/api/v1/auth/refresh/';
      final data = {'refresh': refreshToken};
      final Response response = await dio.post(api, data: data);

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

  // Future<List<Blog>> fetchBlogs() async {
  //   try {
  //     final tokens = await getToken();
  //     final accessToken = tokens['access'];
  //     final response = await dio.get(
  //       '$baseUrl/api/v1/blogs/',
  //       options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
  //     );
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       final dynamic responseData = response.data;
  //       print(responseData);

  //       if (responseData is List) {
  //         // Map dữ liệu phản hồi thành một danh sách các đối tượng Blog
  //         final List<Blog> blogs = responseData
  //             .map((blogData) {
  //               return Blog.fromJson(blogData);
  //             })
  //             .toList()
  //             .cast<Blog>(); // Chuyển đổi kiểu danh sách sang List<Blog>

  //         return blogs;
  //       } else {
  //         // Trả về một danh sách trống nếu responseData không phải là một danh sách
  //         return [];
  //       }
  //     } else {
  //       print('${response.statusCode} : ${response.data.toString()}');
  //       // Trả về một danh sách trống nếu có lỗi
  //       return [];
  //     }
  //   } catch (e) {
  //     print(e);
  //     // Trả về một danh sách trống nếu có lỗi
  //     return [];
  //   }
  // }

  // Future<List<Blog>> fetchBlogs() async {
  //   final tokens = await getToken();
  //   final accessToken = tokens['access'];
  //   final response = await dio.get(
  //     '$baseUrl/api/v1/blogs/',
  //     options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> responseData = response.data;
  //     List<Blog> blogs =
  //         responseData.map((json) => Blog.fromJson(json)).toList();
  //     return blogs;
  //   } else {
  //     return [];
  //   }
  // }
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

  return {'access': accessToken, 'refresh': refreshToken};
}

Future<dynamic> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('refreshToken', refreshToken);
  await prefs.setString('accessToken', accessToken);
  // Kiểm tra xem tokens đã được lưu đúng chưa
}

class LoginGoogle {
  static final _googleSignin = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignin.signIn();
  static Future signOut() => _googleSignin.disconnect();
}
