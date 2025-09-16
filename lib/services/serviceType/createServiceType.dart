import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateServiceType {
  static const String baseUrl = 'http://192.168.29.161:4000';

  /// 🔹 Common request headers
  static Map<String, String> _headers(String token) => {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

  /// 🔹 Common payload builder
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
      "serviceSubType": serviceSubType, // Backend expects capital S
      "status": status,
    };
  }

  /// 🔹 Create ServiceType
  static Future<Map<String, dynamic>> serviceType({
    required String activeSteps,
    required String panNumber,
    required String aadharNumber,
    required String serviceId,
    required String serviceSubType, // Use lower camelCase in param
    required String status,
    required String token,
  }) async {
    try {
      final bodyData = _buildPayload(
        activeSteps: activeSteps,
        panNumber: panNumber,
        aadharNumber: aadharNumber,
        serviceId: serviceId,
        serviceSubType: serviceSubType,
        status: status,
      );

      // ✅ Debugging logs
      print("🟡 [CreateServiceType] API URL => $baseUrl/serviceType/createServiceType");
      print("🟡 [CreateServiceType] Headers => ${_headers(token)}");
      print("📤 [CreateServiceType] Final Payload => $bodyData");

      final response = await http.post(
        Uri.parse('$baseUrl/serviceType/createServiceType'),
        headers: _headers(token),
        body: jsonEncode(bodyData),
      );

      print("📥 [CreateServiceType] Raw Response => ${response.body}");
      print("📥 [CreateServiceType] Status Code => ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        print("✅ [CreateServiceType] Parsed Response => $jsonResponse");
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception("Token expired. Please login again.");
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      print("❌ [CreateServiceType] Exception => $e");
      throw Exception("API Exception: $e");
    }
  }
}
