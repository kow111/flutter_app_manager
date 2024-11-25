import 'dart:convert';

import 'package:app_manager/models/discount/discount_dto.dart';
import 'package:app_manager/models/discount/discount_model.dart';
import 'package:app_manager/services/api_client.dart';

class DiscountService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getDiscounts({int page = 1}) async {
    var response = await _apiClient.getPrivate('/discount?page=$page');
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> discountData = responseData['DT']['discounts'];
        int totalPage = responseData['DT']['totalPages'];

        return {
          'discounts':
              discountData.map((json) => DiscountModel.fromJson(json)).toList(),
          'totalPage': totalPage,
        };
      } else {
        throw Exception('Failed to load discounts');
      }
    } catch (error) {
      throw Exception('Failed to load discounts: $error');
    }
  }

  Future<bool> addDiscount(DiscountDto data) async {
    var response = await _apiClient.postPrivate('/discount', data.toJson());
    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add discount');
      }
    } catch (error) {
      throw Exception('Failed to add discount: $error');
    }
  }
}
