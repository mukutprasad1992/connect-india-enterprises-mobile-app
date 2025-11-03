import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';
class RegisterApi {
  //static const String baseUrl = "http://192.168.29.161:4000";

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
    final url = Uri.parse('$baseUrl/user/register');

    final Map<String, dynamic> bodyData = {
      "email": email,
      "mobileNo": mobileNo,
      "roleId": roleId,
      "password": password,
      "businessName": businessName ?? "N/A",
      "businessRepresentative": (businessRepresentative?.isNotEmpty ?? false)
          ? businessRepresentative
          : "N/A",
      "vendorCode": (vendorCode?.isNotEmpty ?? false) ? vendorCode : "N/A",
      "address": address ?? "N/A",
      "status": status,
    };

    // ✅ Remove any accidental null keys (safety measure)
    bodyData.removeWhere((key, _) => key == null);

    try {
      print("📤 Sending: $bodyData");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      //print("📥 Response (${response.statusCode}): ${response.body}");

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
