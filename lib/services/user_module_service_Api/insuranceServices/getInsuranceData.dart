
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class getAllInsurance {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> getAllInsuranceByServiceId({
    required String serviceId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/insurance/getInsuranceByServiceId/$serviceId'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", 
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Token is invalid or expired");
      } else {
        throw Exception(
            "API Error: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
