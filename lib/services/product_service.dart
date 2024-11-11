import 'dart:convert';

import 'package:app_manager/models/product/product.dart';
import 'package:app_manager/services/api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();
  Future<Map<String, dynamic>> getProducts({int page = 1}) async {
    var response = await _apiClient.getPublic('/product?page=$page');
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> productData = responseData['DT']['products'];
        int totalPage = responseData['DT']['totalPages'];

        return {
          'products':
              productData.map((json) => Product.fromJson(json)).toList(),
          'totalPage': totalPage,
        };
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    }
  }
}
