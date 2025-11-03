import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';
class UpdateVendorStatus {
  //static const String baseUrl = 'http://192.168.29.161:4000';
  static Future<Map<String, dynamic>> updateVendorStatusById({
    required String id,
    required String status,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/user/updateUserStatusById/$id');
    final Map<String, dynamic> body = {"status": status.trim()};

    try {
      //print("🔹 API CALL: $url");
      //print("🔹 Status to update: $status");
      //print("🔑 Token: $token");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      //print("🔹 Response Code: ${response.statusCode}");
      //print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 401) {
        return {
          "status": false,
          "message": "Unauthorized — Invalid or expired token"
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}",
          "body": response.body,
        };
      }
    } catch (e) {
      return {"status": false, "message": "Exception: $e"};
    }
  }
}
