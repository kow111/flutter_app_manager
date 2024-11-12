import 'dart:convert';

import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/services/api_client.dart';

class CategoryService {
  final ApiClient _apiClient = ApiClient();
  Future<List<Category>> getCategories() async {
    var response = await _apiClient.getPublic('/category');
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> categoryData = responseData['DT'];
        return categoryData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      throw Exception('Failed to load categories: $error');
    }
  }
}
