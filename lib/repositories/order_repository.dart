import 'package:app_manager/models/order/order_model.dart';
import '../services/order_service.dart';

class OrderRepository {
  final OrderApiService _apiService = OrderApiService();

  Future<Map<String, dynamic>> fetchOrders(int page, String? status) async {
    return await _apiService.getOrders(page: page, status: status);
  }

  Future<bool> updateOrderStatus(String id, String status) async {
    return await _apiService.updateOrderStatus(id, status);
  }
}
