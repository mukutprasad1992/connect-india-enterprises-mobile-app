import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.29.161:4000';

  static Future<Map<String, dynamic>> uploadDocument({
    required String filePath,
    required String fileType,
    required String description,
    required String folderName,
    required String token, 
  }) async {
    File file = File(filePath);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/uploadDocumentSerciceTypeFile/dynamic'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    request.fields['mediaType'] = fileType;
    request.fields['description'] = description;
    request.fields['folderName'] = folderName;

    // Add Authorization header
    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await http.Response.fromStream(response);
      return jsonDecode(responseData.body);
    } else {
      var responseData = await http.Response.fromStream(response);
      throw Exception(
          'Failed to upload file: ${response.statusCode}, ${responseData.body}');
    }
  }
}
