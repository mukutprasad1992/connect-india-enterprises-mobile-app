import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/consts/appConstants.dart';

class CreateProfileServices {
  // Retrieve saved token
  static Future<String?> getKeyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("KEYTOKEN");
  }

  // Create Profile API
  static Future<Map<String, dynamic>> createProfile({
    required String firstName,
    required String lastName,
    required int mobileNo,
    required String email,
    required String profileImageURL,
  }) async {
    final url = Uri.parse('$baseUrl/profile/createProfile');

    final Map<String, dynamic> bodyData = {
      "firstName": firstName,
      "lastName": lastName,
      "mobileNo": mobileNo,
      "email": email,
      "profileImageURL": profileImageURL,
    };

    try {
      final token = await getKeyToken();

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );
      print("----response-----,$response");      
      print("------response.body------,${response.body}");
     
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "status": true,
          "message": "Profile created successfully",
          "data": jsonDecode(response.body),
        };
      }
       
      else {
        return {
          "status": false,
          "message": "Failed to create profile: ${response.statusCode}",
          "body": response.body,
        };
      }
      
    } catch (e) {
      return {
        "status": false,
        "message": "Network error: $e",
      };
    }
  }
}
