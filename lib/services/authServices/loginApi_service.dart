import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.29.161:4000';

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10)); 

      // Try decoding JSON safely
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        return {
          "status": false,
          "message": "Invalid server response",
          "data": null
        };
      }
    } catch (e) {
      //print("Login error: $e");
      return {
        "status": false,
        "message": "Unable to connect to server",
        "data": null
      };
    }
  }
}
