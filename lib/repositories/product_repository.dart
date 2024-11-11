import 'package:app_manager/models/product/product.dart';
import 'package:app_manager/services/product_service.dart';

class ProductRepository {
  final ProductService _productService = ProductService();
  Future<Map<String, dynamic>> getProducts({int page = 1}) async {
    final result = await _productService.getProducts(page: page);
    return {
      'products': result['products'] as List<Product>,
      'totalPage': result['totalPage'] as int,
    };
  }
}
