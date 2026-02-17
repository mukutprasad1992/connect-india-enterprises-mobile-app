import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';
class UpdateVendorStatus {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }
  static Future<Map<String, dynamic>> updateVendorStatusById({
    required String id,
    required String status,
    
  }) async {

    final url = Uri.parse('$baseUrl/user/updateUserStatusById/$id');
    final Map<String, dynamic> body = {"status": status.trim()};

    try {
      final token = await getKeyToken();
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

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
