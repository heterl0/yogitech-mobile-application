import 'package:dio/dio.dart';
import 'package:yogi_application/api/dioInstance.dart';
import 'package:yogi_application/src/models/account.dart';
import 'package:yogi_application/utils/formatting.dart';

Future<Account?> getUser() async {
  try {
    final url = formatApiUrl('/api/v1/users/me/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Account.fromMap(response.data);
    } else {
      print(
          'Get account detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get account detail error: $e');
    return null;
  }
}

/// Patch user account allow to username and phone
Future<Account?> patchUserAccount(Map<String, dynamic> data) async {
  try {
    final url = formatApiUrl('/api/v1/users/me/');
    final Response response = await DioInstance.patch(url, data: data);
    if (response.statusCode == 200) {
      return Account.fromMap(response.data);
    } else {
      print(
          'Patch account detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Patch account detail error: $e');
    return null;
  }
}

class PasswordChangeRequest {
  String newPassword;
  String reNewPassword;
  String currentPassword;

  PasswordChangeRequest({
    required this.newPassword,
    required this.reNewPassword,
    required this.currentPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'new_password': newPassword,
      're_new_password': reNewPassword,
      'current_password': currentPassword,
    };
  }
}

Future<bool> changePassword(PasswordChangeRequest data) async {
  try {
    final url = formatApiUrl('/api/v1/users/set_password/');
    final Response response = await DioInstance.patch(url, data: data.toMap());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Change password failed with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Change password error: $e');
    return false;
  }
}
