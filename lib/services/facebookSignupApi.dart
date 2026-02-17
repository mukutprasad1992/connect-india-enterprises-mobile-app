import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class FacebookLoginService {
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<Map<String, dynamic>> facebookLogin() async {
    try {
      final token = await getKeyToken(); //  You missed `await`
      if (token == null) {
        throw Exception("Token not found in SharedPreferences");
      }

      final Uri url = Uri.parse('$baseUrl/auth/facebook');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        throw Exception("Unauthorized: Token is invalid");
      } else {
        throw Exception("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (error) {
      throw Exception("Exception while fetching Facebook login: $error");
    }
  }
}
