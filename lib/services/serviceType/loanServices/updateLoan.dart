import 'dart:convert';
import 'package:http/http.dart' as http;

class updateLoanService {
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> updateLoanServiceTypeById({
    required String id,

    // Common fields
    String? serviceSubType,
    String? serviceId,
    String? status,
    String? activeSteps,

    // Personal details
    String? panNumber,
    String? aadharNumber,
    String? motherName,
    String? maritalStatus,
    String? currentAddress,

    // Contact details
    String? yearsOfCity,
    String? alternateNo,
    String? landmark,

    // Employment Details
    String? designation,
    String? companyExp,
    String? totalWorkExp,
    String? officeMobile,
    String? officeAddress,

    // Reference Details
    String? ref1Name,
    String? ref1Mobile,
    String? ref1Address,
    String? ref2Name,
    String? ref2Mobile,
    String? ref2Address,

    // Documents
    String? aadharCardFileKey,
    String? panCardFileKey,
    String? photoFileKey,
    String? salarySlipsFileKey,
    String? bankStatementFileKey,
    int? submit,
    required String token,

  })
   async {
    try {
      // 🔹 Create request body only with non-null fields
      final Map<String, dynamic> body = {
        // Common
        if (serviceSubType != null) "serviceSubType": serviceSubType,
        if (serviceId != null) "serviceId": serviceId,
        if (status != null) "status": status,
        if (activeSteps != null) "activeSteps": activeSteps,

        // Personal
        if (panNumber != null) "panNumber": panNumber,
        if (aadharNumber != null) "aadharNumber": aadharNumber,
        if (motherName != null) "motherName": motherName,
        if (maritalStatus != null) "maritalStatus": maritalStatus,
        if (currentAddress != null) "currentAddress": currentAddress,

        // Contact
        if (yearsOfCity != null) "yearsOfCity": yearsOfCity,
        if (alternateNo != null) "alternateNo": alternateNo,
        if (landmark != null) "landmark": landmark,

        // Employment
        if (designation != null) "designation": designation,
        if (companyExp != null) "companyExp": companyExp,
        if (totalWorkExp != null) "totalWorkExp": totalWorkExp,
        if (officeMobile != null) "officeMobile": officeMobile,
        if (officeAddress != null) "officeAddress": officeAddress,

        // References
        if (ref1Name != null) "ref1Name": ref1Name,
        if (ref1Mobile != null) "ref1Mobile": ref1Mobile,
        if (ref1Address != null) "ref1Address": ref1Address,
        if (ref2Name != null) "ref2Name": ref2Name,
        if (ref2Mobile != null) "ref2Mobile": ref2Mobile,
        if (ref2Address != null) "ref2Address": ref2Address,

        // Documents
        if (aadharCardFileKey != null) "aadharCardFileKey": aadharCardFileKey,
        if (panCardFileKey != null) "panCardFileKey": panCardFileKey,
        if (photoFileKey != null) "photoFileKey": photoFileKey,
        if (salarySlipsFileKey != null) "salarySlipsFileKey": salarySlipsFileKey,
        if (bankStatementFileKey != null) "bankStatementFileKey": bankStatementFileKey,

        // Review
        if (submit != null) "submit": submit,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/loan/updateLoanById/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
        
      );
      print(jsonEncode(body));

      // 🔹 Handle response
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Exception in updateLoanServiceTypeById: $e");
    }
  }
}
