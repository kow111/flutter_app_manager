import 'package:app_manager/models/product/product_model.dart';

class ProductOrderModel {
  final Product product;
  final int quantity;

  ProductOrderModel({
    required this.product,
    required this.quantity,
  });

  factory ProductOrderModel.fromJson(Map<String, dynamic> json) {
    return ProductOrderModel(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}
