import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class UpdateVendor {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> updateVendorById({
    required String id,
    required String email,
    required String mobileNo,
    required String status,
    String? businessName,
    String? businessRepresentative,
    String? vendorCode,
    String? address,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/user/updateUser/$id');

    final Map<String, dynamic> body = {
      "email": email.trim(),
      "mobileNo": mobileNo.trim(),
      "businessName": (businessName?.isNotEmpty ?? false) ? businessName : "N/A",
      "businessRepresentative": (businessRepresentative?.isNotEmpty ?? false)
          ? businessRepresentative
          : "N/A",
      "vendorCode": (vendorCode?.isNotEmpty ?? false) ? vendorCode : "N/A",
      "address": (address?.isNotEmpty ?? false) ? address : "N/A",
      "status": status.trim(),
    };

    try {
      //print("🔹 PUT URL: $url");
      //print("🔹 Request Body: ${jsonEncode(body)}");

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
      return {
        "status": false,
        "message": "Exception in updateVendorById: $e",
      };
    }
  }
}
