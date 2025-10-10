// //http://localhost:4000/insurance/getInsuranceByServiceId/3

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ServiceTypeApi {
//   static const String baseUrl = 'http://192.168.29.161:4000';

//   static Future<Map<String, dynamic>> getAllInsuranceByServiceId({
//     required String serviceId,
//     required String token,
//   }) async {
//     try {
//       final response = await http.get(

//         Uri.parse('$baseUrl/insurance/getInsuranceByServiceId/$serviceId'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },

//       );
//       //print("🔹 Raw API Response: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         // print('@@@@@@@@@ ${responseData.data.isNotEmpty ? responseData.data[0].aadharCardFileKey : 'No data'}');
//         return responseData;
//       } else if (response.statusCode == 401) {
//         throw Exception(" Unauthorized: Token is invalid or expired");
//       } else {
//         throw Exception(
//           "API Error: ${response.statusCode}, Body: ${response.body}",
//         );
//       }
//     } catch (e) {
//       throw Exception(" Exception: $e");
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class getAllInsurance {
  static const String baseUrl = 'http://192.168.29.161:4000';

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

      // Debug logs
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

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
