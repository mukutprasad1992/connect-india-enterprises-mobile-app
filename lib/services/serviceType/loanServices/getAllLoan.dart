import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GetAllLoan {
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> getAllLoanByServiceId({
    required String serviceId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/loan/getloanByServiceId/$serviceId'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      //debugPrint("🔹 Status Code: ${response.statusCode}");
      //debugPrint("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is List) return {'data': decoded};
        throw Exception("Unexpected response format");
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
