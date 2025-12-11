import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class GoogleLoginService {
  // Save backend token
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("AUTH_TOKEN", token);
  }

  // Read backend token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("AUTH_TOKEN");
  }

  // API Call for Google Login (Mobile)
  static Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      
      final response = await http.post(
        Uri.parse("$baseUrl/auth/google/mobile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Your backend returns: { status: true, data: { accessToken: "" } }
        final backendToken = data["data"]?["accessToken"];

        if (backendToken != null) {
          await saveAuthToken(backendToken);
        }

        return data;
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (error) {
      throw Exception("Exception while logging in: $error");
    }
  }
}
