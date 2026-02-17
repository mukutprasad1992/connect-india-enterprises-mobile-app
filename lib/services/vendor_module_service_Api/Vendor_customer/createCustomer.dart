import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class VendorCreateCustomer {

  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<Map<String, dynamic>> createVendorCustomer({
    required String name,
    required String phone,
    required String email,
    required String pincode,
    required String? address,
    
  }) async {
    final url = Uri.parse('$baseUrl/customers/createCustomer');

    final body = {
      "name": name.trim(),
      "email": email.trim(),
      "phone": phone.trim(),
      "pincode": pincode.trim(),
      "address": (address?.isNotEmpty ?? false) ? address : "N/A",
    };

    try {
      final loginToken = await getKeyToken();
      final response = await http.post(
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
      return {"status": false, "message": "Network error: $e"};
    }
  }
}
