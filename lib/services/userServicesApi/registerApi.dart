import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterApi {
  static const String baseUrl = "http://192.168.29.161:4000/user/register";

  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String mobileNo,
    required int roleId,
    required String password,
    String? businessName,
    String? businessRepresentative,
    String? vendorCode,
    String? address,
    required String status,
  }) async {
    final url = Uri.parse(baseUrl);

    final bodyData = {
      "email": email,
      "mobileNo": mobileNo,
      "roleId": roleId,
      "password": password,
      businessName: "N/A",
      "businessRepresentative": businessRepresentative ?? "",
      "vendorCode": vendorCode ?? "",
      "address": address ?? "",
      "status": status,
    };

    try {
      print("📤 Sending: $bodyData"); // debug log

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      print("📥 Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": false,
          "message": "Server error: ${response.statusCode}",
          "body": response.body
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
}
