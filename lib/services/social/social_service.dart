import 'package:ZenAiYoga/models/account.dart';
import 'package:ZenAiYoga/models/social.dart';
import 'package:ZenAiYoga/services/account/account_service.dart';
import 'package:ZenAiYoga/services/auth/auth_service.dart';
import 'package:ZenAiYoga/services/dioInstance.dart';
import 'package:ZenAiYoga/utils/formatting.dart';
import 'package:dio/dio.dart';

Future<Account?> followUser(int userId) async {
  try {
    final url = formatApiUrl('/api/v1/social/follow/');
    final Response response =
        await DioInstance.post(url, data: {'followed': userId});
    if (response.statusCode == 201) {
      final account = await getUser();
      if (account != null) {
        await storeAccount(account);
      }
      return account;
    } else {
      print('Post follow user failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Post follow user error: $e');
    return null;
  }
}

Future<Account?> unfollowUser(int userId) async {
  try {
    final url = formatApiUrl('/api/v1/social/unfollow/$userId/');
    await DioInstance.delete(url);
    final account = await getUser();
    if (account != null) {
      await storeAccount(account);
    }
    return account;
  } catch (e) {
    print('Unfollow user error: $e');
    return null;
  }
}

Future<List<dynamic>> getFollowersById(int userId) async {
  try {
    final url = formatApiUrl('/api/v1/social/followers/$userId/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => Account.fromMap(e)).toList();
      data = data.where((ac) => ac.active_status == 1).toList();
      return data;
    } else {
      print('Get followers failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get followers error: $e');
    return [];
  }
}

Future<List<dynamic>> getFollowingById(int userId) async {
  try {
    final url = formatApiUrl('/api/v1/social/following/$userId/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => Account.fromMap(e)).toList();
      return data;
    } else {
      print('Get following failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get following error: $e');
    return [];
  }
}

Future<List<dynamic>> getFollowers() async {
  try {
    final url = formatApiUrl('/api/v1/social/followers/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => SocialProfile.fromMap(e)).toList();
      data = data.where((ac) => ac.active_status == 1).toList();
      return data;
    } else {
      print('Get followers failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get followers error: $e');
    return [];
  }
}

Future<List<dynamic>> getFollowing() async {
  try {
    final url = formatApiUrl('/api/v1/social/following/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => SocialProfile.fromMap(e)).toList();
      data = data.where((ac) => ac.active_status == 1).toList();
      return data;
    } else {
      print('Get following failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get following error: $e');
    return [];
  }
}

Future<List<dynamic>> searchSocialProfile(String? query) async {
  try {
    final url = formatApiUrl('/api/v1/social/search-profiles/?query=$query');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data =
          response.data.map((e) => SocialProfile.fromMap(e)).toList();
      return data;
    } else {
      print(
          'Search social profile failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Search social profile error: $e');
    return [];
  }
}

Future<dynamic> getSocialProfile(int userId) async {
  try {
    final url = formatApiUrl('/api/v1/social/search-profiles/?query=$userId');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return SocialProfile.fromMap(response.data[0]);
    } else {
      print(
          'Get social profile failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get social profile error: $e');
    return null;
  }
}
