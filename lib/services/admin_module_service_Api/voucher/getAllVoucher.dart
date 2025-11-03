import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';
import '/models/Vouchermodel.dart';

class GetAllVoucher {
  // 🔹 Get stored auth token
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  // 🔹 Fetch all vouchers
  static Future<List<VoucherModel>> getAllCustomervoucher() async {
    try {
      final token = await getKeyToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/voucher/getAllVouchers'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> result = decoded['result'] ?? [];

        final vouchers = result.map((e) => VoucherModel.fromJson(e)).toList();

        // 🧩 Optional debug log
        print("<-- Vouchers Fetched --> ${vouchers.length}");

        return vouchers;
      } else {
        // Handle unexpected responses gracefully
        throw Exception(
          'Failed to load vouchers. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      print(" Error in GetAllVoucher: $e");
      throw Exception("Error fetching vouchers: $e");
    }
  }
}
