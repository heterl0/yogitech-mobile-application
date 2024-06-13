// import 'package:yogi_application/src/services/api_service.dart';

// import '../models/user_profile.dart';
// import 'package:dio/dio.dart'; // Import Dio

// Future<List<UserProfile>> fetchUserProfiles(String? id) async {
//   try {
//     var dio = Dio();
//     final tokens = await getToken();
//     final accessToken = tokens['access']; // Retrieve access token
//     final response = await dio.get(
//       id != null && id.isNotEmpty
//       ? '$baseUrl/api/v1/user-profiles/$id/'
//       : '$baseUrl/api/v1/user-profiles/',
//       options: Options(headers: {'Authorization': 'Bearer $accessToken'}), // Send access token with request
//     );
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final dynamic responseData = response.data;
//       print(responseData);

//       if (responseData is List) {
//         // Map response data to a list of Blog objects
//         final List<UserProfile> profiles = responseData
//             .map((profiles) {
//               return UserProfile.fromJson(profiles);
//             })
//             .toList()
//             .cast<UserProfile>();

//         return profiles;

//       } else {
//         // Return an empty list if responseData is not a list
//         final profile= UserProfile.fromJson(responseData);
//         return [profile];
//       }
//     } else {
//       print('${response.statusCode} : ${response.data.toString()}');
//       // Return an empty list in case of error
//       return [];
//     }
//   } catch (e) {
//     print(e);
//     // Return an empty list in case of error
//     return [];
//   }
// }
