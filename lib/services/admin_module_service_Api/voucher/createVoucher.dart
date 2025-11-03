import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class CreateVoucher {
  // Retrieve saved token
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  // Create Voucher API
  static Future<Map<String, dynamic>> createVoucher({
    required double amount,
    required int vendorId,
    required int customerId,
    required String voucherCode,
    required String validityFrom,
    required String validityTo,
  }) async {
    final url = Uri.parse('$baseUrl/voucher/createVoucher');

    final Map<String, dynamic> bodyData = {
      "amount": amount,
      "vendorId": vendorId,
      "customerId": customerId,
      "voucherCode": voucherCode.isNotEmpty ? voucherCode : "N/A",
      "validityFrom": validityFrom,
      "validityTo": validityTo,
    };
    print("<---bodyData---->$bodyData");
    try {
      final token = await getKeyToken();
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "status": true,
          "message": "Voucher created successfully",
          "data": jsonDecode(response.body),
        };
      } else {
        return {
          "status": false,
          "message": "Failed to create voucher: ${response.statusCode}",
          "body": response.body,
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }
}
