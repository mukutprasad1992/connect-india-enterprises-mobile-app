import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateServiceType {
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> serviceType({
    required String activeSteps,
    required String panNumber,
    required String aadharNumber,
    required String serviceId,
    required String serviceSubType,
    required String status,
    required String token,
  }) async {
    try {
     
      print("🔹 serviceSubType value: $serviceSubType");

      final bodyData = {
        "activeSteps": activeSteps,
        "panNumber": panNumber,
        "aadharNumber": aadharNumber,
        "serviceId": serviceId,
        "ServiceSubType": serviceSubType, //  small case
        "status": status,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/serviceType/createServiceType'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );

      //print("🔹 Status Code: ${response.statusCode}");
      //print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception("Token expired. Please login again.");
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
