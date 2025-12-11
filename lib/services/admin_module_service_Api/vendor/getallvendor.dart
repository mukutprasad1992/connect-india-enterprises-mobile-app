import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/models/Vendor_model.dart';
import '/consts/appConstants.dart';

class GetAllVendorApi {

  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<List<VendorModel>> getAllvendor() async {
    final token = await getKeyToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/getAllVendor'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List vendors = data['data'];
      return vendors.map((json) => VendorModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load vendors: ${response.body}");
    }
  }
}
