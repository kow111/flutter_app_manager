import 'dart:convert';

import 'package:app_manager/models/product/product_model.dart';
import 'package:app_manager/models/product/product_dto.dart';
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

  Future<bool> addProduct(ProductDto data) async {
    var response = await _apiClient.postPrivate('/product', data.toJson());
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add product');
      }
    } catch (error) {
      throw Exception('Failed to add product: $error');
    }
  }
}
