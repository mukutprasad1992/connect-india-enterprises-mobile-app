import 'dart:convert';
import 'package:http/http.dart' as http;

class updateInsuranceService {
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> updateInsuranceServiceTypeById({
    required String id,
    // common fields
    String? serviceSubType,
    String? serviceId,
    String? status,
    String? activeSteps,

    // basic details
    String? panNumber,
    String? aadharNumber,

    // personal details
    Map<String, String>? placeOfBirth,
    String? motherName,
    String? weightKG,
    String? heightCM,
    String? smoker,
    String? alcohol,
    String? income,
    String? occupation,

    // nominee details
  
    String? nomineeName,
    String? nomineeDOB,
    String? nomineeRelation,

    // document section
    String? aadharCardFileKey,
    String? panCardFileKey,
    String? bankProofFileKey,
    String? salarySlipsFileKey,
    String? itrDocumentsFileKey,

    // review section
    int? submit,

    required String token,
  }) async {
    try {
      // 🔹 Common map for all fields
      final Map<String, dynamic> body = {
        if (serviceSubType != null) "serviceSubType": serviceSubType,
        if (serviceId != null) "serviceId": serviceId,
        if (status != null) "status": status,
        if (activeSteps != null) "activeSteps": activeSteps,

        // basic
        if (panNumber != null) "panNumber": panNumber,
        if (aadharNumber != null) "aadharNumber": aadharNumber,

        // personal
        if (placeOfBirth != null) "placeOfBirth": placeOfBirth,
        if (motherName != null) "motherName": motherName,
        if (weightKG != null) "weightKG": weightKG,
        if (heightCM != null) "heightCM": heightCM,
        if (smoker != null) "smoker": smoker,
        if (alcohol != null) "alcohol": alcohol,
        if (income != null) "income": income,
        if (occupation != null) "occupation": occupation,
        

        // nominee
        
        if (nomineeName != null) "nomineeName": nomineeName,
        if (nomineeDOB != null) "nomineeDOB": nomineeDOB,
        if (nomineeRelation != null) "nomineeRelation": nomineeRelation,

        // documents
        if (aadharCardFileKey != null) "aadharCardFileKey": aadharCardFileKey,
        if (panCardFileKey != null) "panCardFileKey": panCardFileKey,
        if (bankProofFileKey != null) "bankProofFileKey": bankProofFileKey,
        if (salarySlipsFileKey != null) "salarySlipsFileKey": salarySlipsFileKey,
        if (itrDocumentsFileKey != null) "itrDocumentsFileKey": itrDocumentsFileKey,

        // review
        if (submit != null) "submit": submit,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/insurance/updateInsuranceById/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        
        body: jsonEncode(body),
      );
      //print("🔹 Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Exception in updateServiceTypeById: $e");
    }
  }
}
