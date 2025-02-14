import 'dart:typed_data';

import 'package:YogiTech/services/auth/auth_service.dart';
import 'package:YogiTech/services/dioInstance.dart';
import 'package:dio/dio.dart';
import 'package:YogiTech/models/account.dart';
import 'package:YogiTech/utils/formatting.dart';

Future<Account?> getUser() async {
  try {
    final url = formatApiUrl('/api/v1/users/me/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      storeAccount(Account.fromMap(response.data));
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

Future<List<Account>> getUserProfiles([String query = '']) async {
  try {
    final url = formatApiUrl('/api/v1/user_profiles/');
    final Response response =
        await DioInstance.get(url, params: {'query': query});
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((data) => Account.fromMap(data))
          .toList();
    } else {
      print('Failed to get user profiles: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error getting user profiles: $e');
    return [];
  }
}

Future<Profile?> getUserProfile() async {
  try {
    final url = formatApiUrl('/api/v1/users/me/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Account.fromMap(response.data).profile;
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

class PatchUserAccountRequest {
  String? username;
  String? phone;
  bool? isPremium;

  PatchUserAccountRequest({
    this.username,
    this.phone,
    this.isPremium,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (username != null) {
      data['username'] = username;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    if (isPremium != null) {
      data['is_premium'] = isPremium;
    }
    return data;
  }
}

/// Patch user account allow to username and phone
Future<Account?> patchUserAccount(PatchUserAccountRequest data) async {
  try {
    final url = formatApiUrl('/api/v1/users/me/');

    final Response response = await DioInstance.patch(url, data: data.toMap());
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

Future<bool?> changePassword(PasswordChangeRequest data) async {
  try {
    final url = formatApiUrl('/api/v1/users/set_password/');
    final Response response = await DioInstance.post(url, data: data.toMap());
    if (response.statusCode == 204) {
      return true;
    } else {
      print('Change password failed with status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    if (e is DioException) {
      // DioError caught, check if response data contains the specific error
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('current_password')) {
          final errors = responseData['current_password'];
          if (errors is List && errors.contains('Invalid password.')) {
            return null;
          } else {
            print('Change password error: ${e.response?.data}');
          }
        } else {
          print('Change password error: ${e.response?.data}');
        }
      } else {
        print('Change password error: ${e.message}');
      }
    } else {
      // Non-Dio error
      print('Change password error: $e');
    }
    return false;
  }
}

class PatchBMIRequest {
  double? weight;
  double? height;
  double? bmi;

  PatchBMIRequest({
    required this.weight,
    required this.height,
    required this.bmi,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (weight != null) {
      data['weight'] = weight;
    }
    if (height != null) {
      data['height'] = height;
    }
    if (bmi != null) {
      data['bmi'] = bmi;
    }
    return data;
  }
}

/// Patch user account allow to username and phone
Future<Profile?> patchBMI(PatchBMIRequest data) async {
  try {
    final Account? currentUser = await retrieveAccount();
    final int profileId = currentUser!.profile.id;
    final url = formatApiUrl('/api/v1/user-profiles/$profileId/');
    final Response response = await DioInstance.patch(url, data: data.toMap());
    if (response.statusCode == 200) {
      final account = await getUser();
      if (account != null) {
        await storeAccount(account);
      }
      return Profile.fromMap(response.data);
    } else {
      print(
          'Patch profile detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    if (e is DioException) {
      final message = e.message;
      print('Patch profile detail error: $message');
    }
    return null;
  }
}

class PatchProfileRequest {
  String? lastName;
  String? firstName;
  String? phone;
  DateTime? birthdate;
  int? gender;
  double? weight;
  double? height;
  double? bmi;

  PatchProfileRequest({
    this.lastName,
    this.firstName,
    this.phone,
    this.birthdate,
    this.gender,
    this.weight,
    this.height,
    this.bmi,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (lastName != null) {
      data['last_name'] = lastName;
    }
    if (firstName != null) {
      data['first_name'] = firstName;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    if (birthdate != null) {
      data['birthdate'] = birthdate?.toIso8601String();
    }
    if (gender != null) {
      data['gender'] = gender;
    }
    if (weight != null) {
      data['weight'] = weight;
    }
    if (height != null) {
      data['height'] = height;
    }
    if (bmi != null) {
      data['bmi'] = bmi;
    }
    return data;
  }
}

Future<Profile?> patchPreLaunch(PatchProfileRequest data) async {
  try {
    final Account? currentUser = await retrieveAccount();
    final int profileId = currentUser!.profile.id;
    final url = formatApiUrl('/api/v1/user-profiles/$profileId/');
    final Response response = await DioInstance.patch(url, data: data.toMap());
    if (response.statusCode == 200) {
      final account = await getUser();
      if (account != null) {
        await storeAccount(account);
      }
      return Profile.fromMap(response.data);
    } else {
      print(
          'Patch profile detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    if (e is DioException) {
      final message = e.message;
      print('Patch profile detail error: $message');
    }
    return null;
  }
}

Future<dynamic> resetPassword(final String email) async {
  final url = formatApiUrl("/api/v1/users/reset_password/");
  try {
    final response = await Dio().post(url, data: {'email': email});

    if (response.statusCode == 204) {
      print(response.statusCode);
      return {'status': response.statusCode, 'message': response.data};
    } else {
      return {'status': response.statusCode, 'message': response.data};
    }
  } catch (e) {
    if (e is DioException) {
      return {'status': e.response!.statusCode, 'message': e.response!.data};
    }
  }
}

Future<Profile?> patchProfile(
    PatchProfileRequest data, Uint8List? binaryImage) async {
  try {
    final Account? currentUser = await retrieveAccount();
    final int profileId = currentUser!.profile.id;
    final url = formatApiUrl('/api/v1/user-profiles/$profileId/');
    // Get the current date and time
    late FormData formData;
    if (binaryImage != null) {
      final now = DateTime.now();

      // Format the date and time as a string
      final timestamp =
          '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';

      // Include the timestamp in the filename
      final filename = 'avatar_$timestamp.jpg';

      formData = FormData.fromMap({
        'avatar': MultipartFile.fromBytes(binaryImage, filename: filename),
        'last_name': data.lastName,
        'first_name': data.firstName,
        'birthdate': data.birthdate?.toIso8601String(),
        'gender': data.gender
      });
    } else {
      formData = FormData.fromMap({
        'last_name': data.lastName,
        'first_name': data.firstName,
        'birthdate': data.birthdate?.toIso8601String(),
        'gender': data.gender,
      });
    }
    final response = await DioInstance.patch(url, data: formData);
    if (data.phone != null) {
      await DioInstance.patch(formatApiUrl('/api/v1/users/me/'),
          data: {'phone': data.phone});
    }
    if (response.statusCode == 200) {
      final account = await getUser();
      if (account != null) {
        await storeAccount(account);
      }
      return Profile.fromMap(response.data);
    } else {
      print(
          'Patch profile detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Patch profile detail error: $e');
    return null;
  }
}

Future<dynamic> getStreakInMonth(int month, int year) async {
  try {
    final url =
        formatApiUrl('/api/v1/streak-in-month/?month=$month&year=$year');
    final Response response = await DioInstance.get(url);
    print('API response received with status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response data: ${response.data}');
      return response.data;
    } else {
      print('Get streak failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get streak error: $e');
    return null;
  }
}

Future<dynamic> getSevenRecentDays() async {
  try {
    final url = formatApiUrl('/api/v1/statistic-seven-recent-days/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      print(
          'Get seven recent days failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get seven recent days error: $e');
    return null;
  }
}
