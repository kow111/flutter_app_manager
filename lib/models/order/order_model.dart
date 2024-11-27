import 'package:app_manager/models/order/product_order_model.dart';
import 'package:app_manager/models/product/product_model.dart';
import 'package:app_manager/models/discount/discount_model.dart';

class Order {
  String id;
  String user;
  List<ProductOrderModel> products;
  double totalAmount;
  String status;
  String paymentMethod;
  String name;
  String address;
  String phone;
  DiscountModel? discountCode;
  String paymentStatus;
  DateTime createdAt;

  Order({
    required this.id,
    required this.user,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.name,
    required this.address,
    required this.phone,
    this.discountCode,
    required this.paymentStatus,
    required this.createdAt,
  });

  // Phương thức tạo đối tượng từ JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    List<ProductOrderModel> productList = (json['products'] as List<dynamic>?)
            ?.map(
              (item) => ProductOrderModel(
                product: Product.fromJson(item['product']),
                quantity: item['quantity'],
              ),
            )
            .toList() ??
        [];
    DiscountModel? discount;
    if (json['discountCode'] != null) {
      discount = DiscountModel.fromJson(json['discountCode']);
    } else {
      discount = null;
    }

    return Order(
      id: json['_id'],
      user: json['user'],
      products: productList,
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      discountCode: discount,
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  @override
  String toString() {
    return 'Order(name: $name, phone: $phone, address: $address, status: $status, '
        'paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, '
        'totalAmount: $totalAmount, createdAt: $createdAt, '
        'products: ${products.map((product) => product.toString()).join(', ')})';
  }
}
