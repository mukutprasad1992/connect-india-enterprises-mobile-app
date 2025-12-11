import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class InquiryService {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<Map<String, dynamic>> getAllServiceTypes() async {
    try {
      final Uri url = Uri.parse('$baseUrl/serviceType/getAllServiceType');
      final token = await getKeyToken(); 
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Debugging log


      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
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
