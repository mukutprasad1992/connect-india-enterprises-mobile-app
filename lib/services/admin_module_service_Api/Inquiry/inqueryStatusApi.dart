import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class InquiryService {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> UpdateAllStatus({
    required String token,
    required String id,
    required String serviceId,
    required String status,
  }) async {
    final Uri url =
        Uri.parse('$baseUrl/serviceType/updateStatus/$id/$serviceId');

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"status": status}),
    );

    
    if (response.statusCode == 401) {
    
      throw Exception(
          "Unauthorized: Token expired or invalid. Please login again.");
    }

    //print("🔹 API Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }
}
