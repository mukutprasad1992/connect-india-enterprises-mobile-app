import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '/modules/user/widgets/investment/widgets/investment_models/citymodel.dart';
import '/controllers/authController.dart';
import 'package:flutter/material.dart';

class CityApi {
  static const String baseUrl = "http://192.168.29.161:4000/city/getCities";

  /// Fetch cities safely
  static Future<List<City>> fetchCities({
    required String? token,
    required BuildContext context,
  }) async {
    // 🔹 Token check before API call
    if (token == null || token.isEmpty || JwtDecoder.isExpired(token)) {
      AuthController.checkLoginStatus(context);
      return []; // Return empty list if token invalid
    }

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded["data"];
        return data.map((json) => City.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        // Token invalid/expired from server side
        AuthController.checkLoginStatus(context);
        return [];
      } else {
        throw Exception("Failed to load cities: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching cities: $e");
    }
  }
}
