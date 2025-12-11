
import 'package:http/http.dart' as http;
import 'package:myapp/consts/appConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReadNotification {

  /// Get stored token
  static Future<String?> getKeytoken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  /// Update Notification Read Status
  static Future<bool> updateReadNotification(
    String id
    )
    async {
    final token = await getKeytoken();

    if (token == null) {
      throw Exception("Token not found.");
    }

    final url = Uri.parse('$baseUrl/notification/updateisRead/$id');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;     // success
      } else {
        throw Exception("Failed: ${response.statusCode} ${response.body}");
      }
    } catch (error) {
      throw Exception("Token Expired or Unauthorized: $error");
    }
  }
}
