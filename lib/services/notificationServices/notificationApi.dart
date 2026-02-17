import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/models/notification_model.dart';
import '/consts/appConstants.dart';

class NotificationService {
  /// 🔹 Get stored Bearer token
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  /// 🔹 Fetch all user notifications
  static Future<List<AppNotification>> getNotifications() async {
    final token = await getKeyToken();
    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please log in again.');
    }

    final url = Uri.parse('$baseUrl/notification/getAllUserNotification');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        final List<dynamic> results = data['result'] ?? [];
        return results.map((json) => AppNotification.fromJson(json)).toList();
      } else {
        throw Exception('API Error: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  /// 🔹 Mark a notification as read
  static Future<void> markAsRead(String notificationId) async {
    final token = await getKeyToken();
    if (token == null || token.isEmpty) {
      throw Exception('No token found. Please log in again.');
    }

    final url = Uri.parse('$baseUrl/notification/updateisRead/$notificationId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read (HTTP ${response.statusCode})');
    }

    final data = json.decode(response.body);
    if (data['status'] != true) {
      throw Exception('Failed to mark notification as read: ${data['message']}');
    }
  }
}
