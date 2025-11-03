import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class UpdateVoucherStatus {

  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }
  
  static Future<Map<String, dynamic>> updateVoucherStatusById({
    required String id,
    required String status,
    
  }) async {
    print("<--------id------->$id");
    final url = Uri.parse('$baseUrl/voucher/updateVoucherStatusById/$id');
    final Map<String, dynamic> body = {"status": status.trim()};

    print("<-----body------>$body");

    try {
      final token = await getKeyToken();
      print("<-----token------>$token");
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
      print("<-----response------>$response");
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
