// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '/consts/appConstants.dart';
// class RegisterApi {
//   //static const String baseUrl = "http://192.168.29.161:4000";

//   static Future<Map<String, dynamic>> registerUser({
//     required String email,
//     required String mobileNo,
//     required int roleId,
//     required String password,
//     String? businessName,
//     String? businessRepresentative,
//     String? vendorCode,
//     String? address,
//     required String status,
//   }) async {
//     final url = Uri.parse('$baseUrl/user/register');

//     final Map<String, dynamic> bodyData = {
//       "email": email,
//       "mobileNo": mobileNo,
//       "roleId": roleId,
//       "password": password,
//       "businessName": businessName ?? "N/A",
//       "businessRepresentative": (businessRepresentative?.isNotEmpty ?? false)
//           ? businessRepresentative
//           : "N/A",
//       "vendorCode": (vendorCode?.isNotEmpty ?? false) ? vendorCode : "N/A",
//       "address": address ?? "N/A",
//       "status": status,
//     };

//     // Remove any accidental null keys (safety measure)
//     bodyData.removeWhere((key, _) => key == null);

//     try {

//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(bodyData),
//       );
//       print('Register API status: ${response.statusCode}');
//       print('Register API body: ${response.body}');

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } 
      
//       else {
//         return {
//           "status": false,
//           "message": "Server error: ${response.statusCode}",
//           "body": response.body
//         };
//       }
//     } catch (e) {
//       return {"status": false, "message": e.toString()};
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class RegisterApi {
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

    // Build body like Postman: only required + non-empty optional fields
    final Map<String, dynamic> bodyData = {
      "email": email,
      "mobileNo": mobileNo,
      "roleId": roleId,
      "password": password,
      "status": status,
      if (businessName != null && businessName.trim().isNotEmpty)
        "businessName": businessName,
      if (businessRepresentative != null &&
          businessRepresentative.trim().isNotEmpty)
        "businessRepresentative": businessRepresentative,
      if (vendorCode != null && vendorCode.trim().isNotEmpty)
        "vendorCode": vendorCode,
      if (address != null && address.trim().isNotEmpty)
        "address": address,
    };

    // (Optional) extra safety: remove null values if any slip in
    bodyData.removeWhere((_, v) => v == null);

    try {
      final payload = jsonEncode(bodyData);
      print('Register payload: $payload');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      // Treat any 2xx as success
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        return {
          "status": true,
          "message": "Registration succeeded",
          "result": decoded,
        };
      } else {
        // Try to read backend error message
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            return {
              "status": decoded['status'] ?? false,
              "message": decoded['message'] ??
                  'Server error: ${response.statusCode}',
              "code": response.statusCode,
              "body": decoded,
            };
          }
        } catch (_) {
          // fall through to generic error
        }

        return {
          "status": false,
          "message": "Server error: ${response.statusCode}",
          "code": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e) {
      return {
        "status": false,
        "message": e.toString(),
      };
    }
  }
}
