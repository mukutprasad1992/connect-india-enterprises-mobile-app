import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/vendor_module/vendor_customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class GetAllVendorCustomer {

  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<int?> getLoginkey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("KEYLOGINID");
  }
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<List<VendorCustomerModel>> getAllCustomerByVendorId({
    required String vendorId,

  }) async {
    try {
      // final loginId = await getLoginkey();
      final loginToken = await getKeyToken();
      final response = await http.get(
        Uri.parse('$baseUrl/customer/getAllCustomerByVendorId/$vendorId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $loginToken",
        },
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'] ?? body;
        return data.map((e) => VendorCustomerModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
