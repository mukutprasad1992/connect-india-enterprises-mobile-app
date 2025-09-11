import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/models/Vendor_model.dart';
//import '/controllers/authController.dart';
import '/consts/appConstants.dart';
class VendorApi {
  static const String baseUrl = "http://192.168.29.161:4000/user/getAllVendor";

  static Future<List<Vendor>> fetchVendors() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(KEYTOKEN);

    if (token == null) {
      throw Exception("No token found. Please login again.");
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    //print("📩 Response Code: ${response.statusCode}");
    //print("📩 Response Body: ${response.body}");


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List vendors = data['data'];
      return vendors.map((json) => Vendor.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load vendors: ${response.body}");
    }
  }
}
