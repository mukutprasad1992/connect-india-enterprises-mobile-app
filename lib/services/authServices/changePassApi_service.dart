import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';
class ApiService {
  //final String baseUrl = 'http:// 192.168.29.161:4000';

  Future<Map<String, dynamic>?> changePassword(
      String token, String oldPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/changePassword'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
        body: jsonEncode({
          'oldPassword': oldPassword, 
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return null;
    }
  }
}
