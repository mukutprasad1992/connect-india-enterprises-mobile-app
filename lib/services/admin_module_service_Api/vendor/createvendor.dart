import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class CreateVendor {
  //static const String baseUrl = "http://192.168.29.161:4000";

  static Future<Map<String, dynamic>> createVendor({
    required String email,
    required String mobileNo,
     required int roleId,
    required String status,
    String? businessName,
    String? businessRepresentative,
    String? vendorCode,
    String? address,
  }) async {
    final url = Uri.parse('$baseUrl/user/register/');

    final Map<String, dynamic> bodyData = {
      "email": email.trim(),
      "mobileNo": mobileNo.trim(),
      "roleId": roleId,  
      "status": status,
      "businessName": (businessName?.isNotEmpty ?? false) ? businessName : "N/A",
      "businessRepresentative": (businessRepresentative?.isNotEmpty ?? false) ? businessRepresentative : "N/A",
      "vendorCode": (vendorCode?.isNotEmpty ?? false) ? vendorCode : "N/A",
      "address": (address?.isNotEmpty ?? false) ? address : "N/A",
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
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
      return {"status": false, "message": "Network error: $e"};
    }
  }
}
