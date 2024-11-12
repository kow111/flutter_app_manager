import 'dart:convert';
import 'dart:io';

import 'package:app_manager/services/api_client.dart';

class UploadService {
  final ApiClient _apiClient = ApiClient();

  Future<String> uploadImage(File file) async {
    try {
      var response = await _apiClient.uploadImage(file);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String link = responseData['DT'];
        return link;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }
}
