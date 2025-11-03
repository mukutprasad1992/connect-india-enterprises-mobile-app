import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class CreateLoanService {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Map<String, String> _headers(String token) => {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  static Map<String, dynamic> _buildPayload({
    required String activeSteps,
    required String serviceId,
    required String serviceSubType,
    required String status,
    required String panNumber,
    required String aadharNumber,
    required String motherName,
    required String maritalStatus,
    required String currentAddress,
  }) {
    return {
      "activeSteps": activeSteps,
      "panNumber": panNumber,
      "aadharNumber": aadharNumber,
      "motherName": motherName,
      "maritalStatus": maritalStatus,
      "currentAddress": currentAddress,
      "serviceId": serviceId,
      "serviceSubType": serviceSubType,
      "status": status,
    };
  }

  /// 🔹 Create ServiceType
  static Future<Map<String, dynamic>> createLoanByserviceType({
    required String activeSteps,
    required String panNumber,
    required String aadharNumber,
    required String motherName,
    required String maritalStatus,
    required String currentAddress,
    required String serviceId,
    required String serviceSubType,
    required String status,
    required String token,
  }) async {
    try {
      final bodyData = _buildPayload(
        activeSteps: activeSteps,
        panNumber: panNumber,
        aadharNumber: aadharNumber,
        motherName: motherName,
        maritalStatus: maritalStatus,
        currentAddress: currentAddress,
        serviceId: serviceId,
        serviceSubType: serviceSubType,
        status: status,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/loan/createLoan'),
        headers: _headers(token),
        body: jsonEncode(bodyData),
      );

      //print(" [CreateServiceType] Raw Response => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] != true) {
          throw Exception(
              "API failed: ${jsonResponse['message'] ?? 'Unknown error'}");
        }
        return jsonResponse;
      } else {
        // Handle non-200 responses explicitly
        throw Exception(
            "API Error: ${response.statusCode} ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("API Exception: $e");
    }
  }
}
