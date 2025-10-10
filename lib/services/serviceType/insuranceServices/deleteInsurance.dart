import 'dart:convert';
import 'package:http/http.dart' as http;

class deleteInsuranceApi{
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> DeleteInsuranceById({
    required String token,
    required String id,
  }) async {
    final Uri url = Uri.parse('$baseUrl/insurance/deleteInsuranceById/$id');
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      //body: jsonEncode({"status": status}),
    );

    //print("🔹 API Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ServiceTypeApi {
//   static const String baseUrl = 'http://192.168.29.161:4000';

//   /// 🟢 Main function: delete service type
//   static Future<Map<String, dynamic>> deleteServiceType({
//     required String token,
//     required String id,
//   }) async {
//     final Uri url = Uri.parse('$baseUrl/serviceType/deleteServiceTypeById/$id');

//     final response = await http.delete(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     // 🟢 Success
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     }
//     // 🔴 Unauthorized → Token expired or invalid
//     else if (response.statusCode == 401) {
//       throw Exception("Unauthorized: Token expired or invalid.");
//     }
//     // ⚠️ Other error
//     else {
//       throw Exception("API Error: ${response.statusCode} ${response.body}");
//     }
//   }

//   /// 🟢 Example: refresh token API (adjust URL & body as per your backend)
//   static Future<String> refreshToken(String refreshToken) async {
//     final Uri url = Uri.parse('$baseUrl/auth/refresh');

//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"refreshToken": refreshToken}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data["accessToken"]; // 👈 backend के response के हिसाब से बदलें
//     } else {
//       throw Exception("Failed to refresh token: ${response.body}");
//     }
//   }
// }
