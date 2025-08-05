import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  //final String baseUrl = 'http://localhost:4000';
  final String baseUrl = 'http://192.168.29.69:4000';

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); 
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }
}
