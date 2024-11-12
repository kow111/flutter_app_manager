import 'dart:convert';

import 'package:app_manager/models/color/color.dart';
import 'package:app_manager/services/api_client.dart';

class ColorService {
  final ApiClient _apiClient = ApiClient();
  Future<List<Color>> getColors() async {
    var response = await _apiClient.getPublic('/color');
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> colorData = responseData['DT'];
        return colorData.map((json) => Color.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load colors');
      }
    } catch (error) {
      throw Exception('Failed to load colors: $error');
    }
  }
}
