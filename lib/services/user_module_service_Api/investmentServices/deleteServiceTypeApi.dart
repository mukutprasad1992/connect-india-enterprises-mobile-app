import 'dart:convert';
import 'package:http/http.dart' as http;
import '/consts/appConstants.dart';

class ServiceTypeApi {
  //static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> DeleteServiceType({
    required String token,
    required String id,
  }) async {
    final Uri url = Uri.parse('$baseUrl/serviceType/deleteServiceTypeById/$id');

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      //body: jsonEncode({"status": status}),
    );



    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }
}
