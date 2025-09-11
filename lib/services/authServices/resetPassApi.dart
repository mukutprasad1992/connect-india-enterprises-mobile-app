import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPassApi {
  //final String baseUrl = 'http://localhost:4000/auth/resetPassword';
  
  final String baseUrl = 'http://192.168.29.161:4000/auth/resetPassword';

  Future<Map<String, dynamic>> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "newPassword": newPassword,
          "token": token,
        }),
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {"status": false, "message": "Error: ${e.toString()}"};
    }
  }
}
