import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceTypeApi {
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> updateServiceTypeById({
    required String id,
    // common of all section 
    
    String? serviceSubType,
    String? serviceId,
    String? status,
    String? activeSteps,

    //basic detaisls
    String? panNumber,   // 🔹 add this
    String? aadharNumber,

    //personal details section

    String? email,
    String? income,
    String?netGrossProfit,
    String? mobile,
    String? occupation,
    Map<String, String>? placeOfBirth,

    // nominee fields

    String? nomineeIdType,
    String? nomineeId,
    String? nomineeMobile,
    String? nomineeRelation,
    // Documents Section 

    String? aadhaarCardFileKey,
    String? panCardFileKey,
    String? bankProofFileKey,
    String? salarySlipsFileKey,
    String? itrDocumentsFileKey,

    // review section

    int? isDetailsConfirmed,

    

    required String token,
  }) async {
    try {
      Map<String, dynamic> body = {};

      if (serviceSubType != null) body["serviceSubType"] = serviceSubType;
      if (email != null) body["email"] = email;
      if (income != null) body["income"] = income;
      if (mobile != null) body["mobile"] = mobile;
      if (occupation != null) body["occupation"] = occupation;
      if (placeOfBirth != null) body["placeOfBirth"] = placeOfBirth;
      if (serviceId != null) body["serviceId"] = serviceId;
      if (status != null) body["status"] = status;
      if (activeSteps != null) body["activeSteps"] = activeSteps;
      if (aadhaarCardFileKey != null) body["aadhaarCardFileKey"] = aadhaarCardFileKey;
      if (panCardFileKey != null) body["panCardFileKey"] = panCardFileKey;
      if (bankProofFileKey != null) body["bankProofFileKey"] = bankProofFileKey;
      if (salarySlipsFileKey != null) body["salarySlipsFileKey"] = salarySlipsFileKey;
      if (itrDocumentsFileKey != null) body["itrDocumentsFileKey"] = itrDocumentsFileKey;
      if (isDetailsConfirmed != null) body["isDetailsConfirmed"] = isDetailsConfirmed;

      // nominee details
      if (nomineeIdType != null) body["nomineeIdType"] = nomineeIdType;
      if (nomineeId != null) body["nomineeId"] = nomineeId;
      if (nomineeMobile != null) body["nomineeMobile"] = nomineeMobile;
      if (nomineeRelation != null) body["nomineeRelation"] = nomineeRelation;

      final response = await http.put(
        Uri.parse('$baseUrl/serviceType/updateServiceTypeById/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          " API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception(" Exception: $e");
    }
  }
}
