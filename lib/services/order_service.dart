import 'dart:convert';
import 'package:app_manager/models/order/order_model.dart';
import 'package:app_manager/services/api_client.dart';

class OrderApiService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getOrders({int page = 1, String? status}) async {
    if (status == 'ALL') {
      status = '';
    }
    var response = await _apiClient
        .getPrivate('/order/admin?page=$page&status=${status ?? 'CONFIRMED'}');
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> ordersData = responseData['DT']['orders'];
        int totalPage = responseData['DT']['totalPages'];

        return {
          'orders': ordersData.map((json) => Order.fromJson(json)).toList(),
          'totalPage': totalPage,
        };
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (error) {
      throw Exception('Error to load orders: $error');
    }
  }

  Future<bool> updateOrderStatus(String id, String status) async {
    var response = await _apiClient.putPrivate(
      '/order/$id/status',
      {'status': status},
    );

    try {
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update order status');
      }
    } catch (error) {
      throw Exception('Failed to update order status: $error');
    }
  }
}
