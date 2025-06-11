import 'package:ZenAiYoga/services/dioInstance.dart';
import 'package:dio/dio.dart';
import 'package:ZenAiYoga/models/event.dart';
import 'package:ZenAiYoga/utils/formatting.dart';

Future<List<dynamic>> getEvents() async {
  try {
    final url = formatApiUrl('/api/v1/events/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      List<dynamic> data = response.data.map((e) => Event.fromMap(e)).toList();
      return data;
    } else {
      print('Get events failed with status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Get events error: $e');
    return [];
  }
}

Future<Event?> getEvent(int id) async {
  try {
    final url = formatApiUrl('/api/v1/events/$id/');
    final Response response = await DioInstance.get(url);
    if (response.statusCode == 200) {
      return Event.fromMap(response.data);
    } else {
      print('Get event detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Get event detail error: $e');
    return null;
  }
}

Future<CandidateEvent?> joinEvent(int id) async {
  try {
    final data = {"event": id};
    final url = formatApiUrl('/api/v1/event-candidates/');
    final response = await DioInstance.post(url, data: data);
    if (response.statusCode == 201) {
      print(response.data);
      return CandidateEvent.fromMap(response.data);
    } else {
      print(
          'Join event detail failed with status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Join event detail error: $e');
    return null;
  }
}

Future<CandidateEvent?> updateStatusCandidateEvent(int id, int status) async {
  try {
    final url = formatApiUrl('/api/v1/event-candidates/$id/');
    final data = {"active_status": status};
    final response = await DioInstance.patch(url, data: data);
    if (response.statusCode == 200) {
      print(response.data);
      return CandidateEvent.fromMap(response.data);
    } else {
      print(
          'Giveup event detail failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Give up event detail error: $e');
    return null;
  }
  return null;
}
