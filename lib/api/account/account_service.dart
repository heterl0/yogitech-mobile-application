import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:yogi_application/api/auth/auth_service.dart';
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

  PatchUserAccountRequest({
    required this.username,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (username != null) {
      data['username'] = username;
    }
    if (phone != null) {
      data['phone'] = phone;
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

Future<bool> changePassword(PasswordChangeRequest data) async {
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
    print('Change password error: $e');
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
    print(data.toMap());
    final url = formatApiUrl('/api/v1/user-profiles/$profileId/');
    final Response response = await DioInstance.patch(url, data: data.toMap());
    if (response.statusCode == 200) {
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

  PatchProfileRequest({
    this.lastName,
    this.firstName,
    this.phone,
    this.birthdate,
    this.gender,
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
    return data;
  }
}

// Update profile
Future<Profile?> patchProfile(PatchProfileRequest data) async {
  try {
    final Account? currentUser = await retrieveAccount();
    final int profileId = currentUser!.profile.id;
    final url = formatApiUrl('/api/v1/user-profiles/$profileId/');
    final response = await DioInstance.patch(url, data: data.toMap());
    final accountRes = await DioInstance.patch(
        formatApiUrl('/api/v1/users/me/'),
        data: data.toMap());
    if (response.statusCode == 200 && accountRes.statusCode == 200) {
      await storeAccount(Account.fromMap(accountRes.data));
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

Future<Profile?> patchAvatar(Uint8List binaryImage) async {
  try {
    final Account? currentUser = await retrieveAccount();
    final int profileId = currentUser!.profile.id;
    final url = formatApiUrl('/api/v1/user-profiles/$profileId/');
    // Get the current date and time
    final now = DateTime.now();

    // Format the date and time as a string
    final timestamp =
        '${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}';

    // Include the timestamp in the filename
    final filename = 'avatar_$timestamp.jpg';
    final response = await DioInstance.patch(url, data: {
      'avatar': MultipartFile.fromBytes(binaryImage, filename: filename),
    });
    if (response.statusCode == 200) {
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
