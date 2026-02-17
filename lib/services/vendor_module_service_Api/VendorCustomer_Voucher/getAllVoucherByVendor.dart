import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';
import '/models/vendor_module/vendor_voucherModel.dart';

class GetAllVoucher {
  /// 🔹 Get stored Bearer token
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  static Future<List<VoucherModel>> getAllVoucherByVendor() async {
    try {
      final token = await getKeyToken();

      final url = Uri.parse('$baseUrl/voucher/getAllVoucherByVendor');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to fetch vouchers: ${response.statusCode}");
      }

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['status'] == true) {
        final List<dynamic> data = body['result'] ?? [];
        return data.map((e) => VoucherModel.fromJson(e)).toList();
      } else {
        throw Exception("API Error: ${body['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      throw Exception("Exception in getAllVoucherByVendor: $e");
    }
  }
}
