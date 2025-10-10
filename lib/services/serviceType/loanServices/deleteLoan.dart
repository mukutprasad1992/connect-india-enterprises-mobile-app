import 'dart:convert';
import 'package:http/http.dart' as http;

class deleteLoanApi{
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> DeleteLoanById({
    required String token,
    required String id,
  }) async {
    final Uri url = Uri.parse('$baseUrl/loan/deleteLoanById/$id');
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
