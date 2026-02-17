import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '/controllers/authController.dart';
import '/models/citymodel.dart';
import 'package:flutter/material.dart';
import '/consts/appConstants.dart';
class CityApi {
  //static const String baseUrl = "http://192.168.29.161:4000";

  /// Fetch cities safely
  static Future<List<City>> fetchCities({
    required String? token,
    required BuildContext context,
  }) async {
    // 🔹 Token check before API call
    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      AuthController.checkLoginStatus(context);
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/city/getCities'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded["data"] ?? [];
        return data.map((json) => City.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        AuthController.checkLoginStatus(context);
        return [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
