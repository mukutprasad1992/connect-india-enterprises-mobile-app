import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';
class ForgotPassApi {
  //final String baseUrl = 'http:// 192.168.29.161:4000';

  Future<Map<String, dynamic>?> sendResetLink(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgotPassword');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // contains status and message
      } else {
        return {
          'status': false,
          'message': 'Failed to send reset link. Try again.'
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Error: ${e.toString()}'
      };
    }
  }
}
