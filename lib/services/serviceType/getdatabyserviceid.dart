import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceTypeApi {
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> getServiceTypeByServiceId({
    required String serviceId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        
        Uri.parse('$baseUrl/serviceType/getServiceTypeByServiceId/$serviceId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", 
        },
        
      );
      //print("🔹 Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else if (response.statusCode == 401) {
        throw Exception(" Unauthorized: Token is invalid or expired");
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception(" Exception: $e");
    }
  }
}
