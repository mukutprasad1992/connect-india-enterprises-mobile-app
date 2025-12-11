import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';


class getTotalAmount{

  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<Map<String, dynamic>> getTotalAmountAndServiecsByUserIdServiceType() async {
    try{

      final token = await getKeyToken();
      final Uri url = Uri.parse('$baseUrl/serviceType/getTotalAmountAndServiecsByUserIdServiceType');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },

      );
      
      if (response.statusCode == 200){
        return jsonDecode(response.body);
      }
      else if(response.statusCode == 401){
        throw Exception("Unauthorized: Token is invalid or expired");
      }
      else {
        throw Exception(
          "API Error: ${response.statusCode}, Body: ${response.body}",
        );
      }
    }
    
    catch (error){
      throw Exception("Exception while fetching customers: $error");
    }
  }
}