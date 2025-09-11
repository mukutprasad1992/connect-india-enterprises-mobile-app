import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/models/notification_model.dart';
//import '/controllers/authController.dart'; 
import '/consts/appConstants.dart';
class NotificationService {
  static const String baseUrl =
      "http://192.168.29.161:4000/notification/getAllUserNotification";

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
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Token invalid or expired.');
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }
}
