import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/models/notification_model.dart';
import '/consts/appConstants.dart';

// class NotificationService {
//   static const String baseUrl =
//       "http://192.168.29.161:4000/notification/getAllUserNotification";

//   /// 🔹 Get all notifications
  
//   static Future<List<AppNotification>> getNotifications() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(KEYTOKEN);

//     if (token == null || token.isEmpty) {
//       throw Exception('No token found. Please log in again.');
//     }

//     final response = await http.get(
//       Uri.parse(baseUrl),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//     //print('--------- Response status----------: ${response.statusCode}');
//     //print('========Response body=======: ${response.body}');

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       //print('---------Decoded JSON-------: $data'); 
//       if (data['status'] == true) {
//         final List<dynamic> result = data['result'];
//         return result.map((json) => AppNotification.fromJson(json)).toList();
//       } else {
//         throw Exception('API Error: ${data['message']}');
//       }
//     } else if (response.statusCode == 401) {
//       throw Exception('Unauthorized: Token invalid or expired.');
//     } else {
//       throw Exception(
//           'Failed to load notifications: ${response.statusCode}');
//     }
//   }

//   /// 🔹 Mark a notification as read
//   static Future<void> markAsRead(String notificationId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(KEYTOKEN);

//     if (token == null || token.isEmpty) {
//       throw Exception('No token found. Please log in again.');
//     }
//     //print('Mark as read request&&&&&&&&: ${json.encode({'notificationId': notificationId})}');
//     //print('Token%%%%%%%%%%: $token');

//     final response = await http.post(
//       Uri.parse('http://192.168.29.161:4000/notification/markAsRead'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({'notificationId': notificationId}),
//     );
//     //print('Response status @@@@@@@: ${response.statusCode}');
//     //print('Response body#######: ${response.body}');

//     if (response.statusCode != 200) {
//       throw Exception('Failed to mark notification as read');
//     }
//   }
  
// }



class NotificationService {
  static const String baseUrl =
      "http://192.168.29.161:4000/notification/getAllUserNotification";

  // 🔹 Get all notifications
  static Future<List<AppNotification>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEYTOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        final List<dynamic> result = data['result'];
        return result.map((json) => AppNotification.fromJson(json)).toList();
      } else {
        throw Exception('API Error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  // 🔹 Mark a notification as read
  static Future<void> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEYTOKEN);

    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please log in again.');
    }

    final url =
        'http://192.168.29.161:4000/notification/updateisRead/$notificationId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    if (data['status'] != true) {
      throw Exception('Failed to mark notification as read: ${data['message']}');
    }
  }
}
