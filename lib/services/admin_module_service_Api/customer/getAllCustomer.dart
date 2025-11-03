import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class GetAllCustomer {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> getAllCustomer({
    required String token,
  }) async {
    try {
      final Uri url = Uri.parse('$baseUrl/customer/getAllCustomer');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Token is invalid or expired");
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Exception while fetching customers: $e");
    }
  }
}
