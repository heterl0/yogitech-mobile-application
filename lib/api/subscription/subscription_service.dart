import 'package:YogiTech/api/account/account_service.dart';
import 'package:YogiTech/api/auth/auth_service.dart';
import 'package:YogiTech/api/dioInstance.dart';
import 'package:YogiTech/utils/formatting.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../src/models/subscriptions.dart';

Future<List<dynamic>> getSubscriptions() async {
  try {
    final url = formatApiUrl('/api/v1/subscriptions/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data.map((e) => Subscription.fromMap(e)).toList();
      return data;
    } else {
      print('Get subscription failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get subscription error: $e');
    return [];
  }
}

Future<Subscription?> getSubscription(int id) async {
  try {
    final url = formatApiUrl('/api/v1/subscriptions/$id/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Subscription.fromMap(response.data);
    } else {
      print('Get Subscription detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get Subscription detail error: $e');
    return null;
  }
}

Future<List<dynamic>> getUserSubscriptions() async {
  try {
    final url = formatApiUrl('/api/v1/user-subscriptions/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data.map((e) => UserSubscription.fromMap(e)).toList();
      return data;
    } else {
      print('Get UserSubscription failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get UserSubscription error: $e');
    return [];
  }
}

Future<UserSubscription?> subscribe(int subscription,int subscriptionType) async {
   try {
    final url = formatApiUrl('/api/v1/user-subscriptions/');
    final data = {
      'subscription': subscription,
      'subscriptionType': subscriptionType,
    };
    final Response response = await DioInstance.post(url,data:data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      UserSubscription data = UserSubscription.fromMap(response.data);
      final user = await getUser();
      if (user != null)  {
        storeAccount(user);
      }
      return data;
    }
    else {
      print('Get UserSubscription failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get UserSubscription error: $e');
    if (e is DioException) {
      if (e.response?.statusCode == 400) {
      } else {
        
      }
    }
    return null;
  }
}

Future<UserSubscription?> cancelSubscription(int id) async {
  final now = DateTime.now().toUtc();
  try {
    final url = formatApiUrl('/api/v1/user-subscriptions/$id/');
    final data = {
      "active_status": 0,
      "cancel_at": now.toString()
    };
    final Response response = await DioInstance.patch(url, data: data);
    if (response.statusCode == 200) {
      return UserSubscription.fromMap(response.data);
    } else {
      print('Cancel UserSubscription failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Cancel UserSubscription detail error: $e');
    return null;
  }
}

Future<UserSubscription?> expiredSubscription(int id) async {
  try {
    final url = formatApiUrl('/api/v1/user-subscriptions/$id/');
    final data = {
      "active_status": 0,
    };
    final Response response = await DioInstance.patch(url, data: data);
    if (response.statusCode == 200) {
      return UserSubscription.fromMap(response.data);
    } else {
      print('Cancel UserSubscription failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Cancel UserSubscription detail error: $e');
    return null;
  }
}