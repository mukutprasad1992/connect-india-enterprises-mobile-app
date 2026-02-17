import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class UpdateVoucher {
  // Retrieve saved token
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  // Update Voucher By ID API
  static Future<Map<String, dynamic>> updateVoucherById({
    required int id,
    required double amount,
    required int vendorId,
    required int customerId,
    required String voucherCode,
    required String validityFrom,
    required String validityTo,
  }) async {
    final url = Uri.parse('$baseUrl/voucher/updateVoucherById/$id');

    final Map<String, dynamic> bodyData = {
      "amount": amount,
      "vendorId": vendorId,
      "customerId": customerId,
      "voucherCode": voucherCode.isNotEmpty ? voucherCode : "N/A",
      "validityFrom": validityFrom,
      "validityTo": validityTo,
    };
    try {
      final token = await getKeyToken();
      final response = await http.put(
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
          "message": "Voucher updated successfully",
          "data": jsonDecode(response.body),
        };
      } else {
        return {
          "status": false,
          "message": "Failed to update voucher: ${response.statusCode}",
          "body": response.body,
        };
      }
    } catch (e) {
      return {"status": false, "message": "Network error: $e"};
    }
  }
}
