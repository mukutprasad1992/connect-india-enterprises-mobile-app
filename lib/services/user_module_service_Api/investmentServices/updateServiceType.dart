import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class ServiceTypeApi {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> updateServiceTypeById({
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
    String? email,
    String? income,
    String? netGrossProfit,
    String? mobile,
    String? occupation,
    Map<String, String>? placeOfBirth,

    // nominee details
    String? nomineeIdType,
    String? nomineeId,
    String? nomineeMobile,
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
        if (email != null) "email": email,
        if (income != null) "income": income,
        if (netGrossProfit != null) "netGrossProfit": netGrossProfit,
        if (mobile != null) "mobile": mobile,
        if (occupation != null) "occupation": occupation,
        if (placeOfBirth != null) "placeOfBirth": placeOfBirth,

        // nominee
        if (nomineeIdType != null) "nomineeIdType": nomineeIdType,
        if (nomineeId != null) "nomineeId": nomineeId,
        if (nomineeMobile != null) "nomineeMobile": nomineeMobile,
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
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Exception in updateServiceTypeById: $e");
    }
  }
}
