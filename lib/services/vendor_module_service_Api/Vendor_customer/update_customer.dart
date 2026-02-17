import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateVendorCustomer {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<Map<String, dynamic>> updateVendorCustomerById({
    required String id,
    required String email,
    required String name,
    required String phone,
    String? pincode,
    String? address,
    
  }) async {
    final loginToken = await getKeyToken();
    final url = Uri.parse('$baseUrl/customers/updateCustomer/$id');

    final body = {
      "name": name.trim(),
      "email": email.trim(),
      "phone": phone.trim(),
      "pincode": (pincode?.isNotEmpty ?? false) ? pincode : "N/A",
      "address": (address?.isNotEmpty ?? false) ? address : "N/A",
    };

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $loginToken",
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
