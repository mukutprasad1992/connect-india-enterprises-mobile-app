import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceTypeApi {
  static const String baseUrl = 'http://192.168.29.161:4000';

  /// Fetch all service types with Bearer token authorization
  static Future<Map<String, dynamic>> getAllServiceType({
    required String token,
  }) async {
    try {
      final Uri url = Uri.parse('$baseUrl/serviceType/getAllServiceType');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Debugging log
      //print("🔹 API Response Status: ${response.statusCode}");
      //Eprint("🔹 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("--responseData-------${responseData}");
        return responseData;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Token is invalid or expired");
      } else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Exception while fetching service types: $e");
    }
  }
}
