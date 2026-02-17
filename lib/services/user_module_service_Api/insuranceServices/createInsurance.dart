import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class CreateInsuranceService{
  //static const String baseUrl = 'http://192.168.29.161:4000';

  /// 🔹 Common request headers
  static Map<String, String> _headers(String token) => {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };
  static Map<String, dynamic> _buildPayload({
    required String activeSteps,
    required String panNumber,
    required String aadharNumber,
    required String serviceId,
    required String serviceSubType,
    required String status,
  }) {
    return {
      "activeSteps": activeSteps,
      "panNumber": panNumber,
      "aadharNumber": aadharNumber,
      "serviceId": serviceId,
      "serviceSubType": serviceSubType,
      "status": status,
    };
  }

  static Future<Map<String, dynamic>> createInsurancebyserviceType(
    {
      required String activeSteps,
      required String panNumber,
      required String aadharNumber,
      required String serviceId,
      required String serviceSubType, 
      required String status,
      required String token,
    }
  )
  async {
    try {
      final bodyData = _buildPayload(
        activeSteps: activeSteps,
        panNumber: panNumber,
        aadharNumber: aadharNumber,
        serviceId: serviceId,
        serviceSubType: serviceSubType,
        status: status,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/insurance/createInsurance/'),
        headers: _headers(token),
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception("Token expired. Please login again.");
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("API Exception: $e");
    }
  }
}
