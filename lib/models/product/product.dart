import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/models/color/color.dart';

class Product {
  final String id;
  final String productName;
  final String description;
  final String size;
  final List<Category> category;
  final int quantity;
  final List<String> imageUrl;
  final int price;
  final Color color;
  final String condition;

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.size,
    required this.category,
    required this.quantity,
    required this.imageUrl,
    required this.price,
    required this.color,
    required this.condition,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var listCategory = (json['category'] as List?)
            ?.map(
              (category) => Category.fromJson(category),
            )
            .toList() ??
        [];

    var color = json['color'] != null
        ? Color.fromJson(json['color'])
        : Color(id: '', name: '');
    return Product(
      id: json['_id'],
      productName: json['productName'],
      description: json['description'],
      size: json['size'],
      category: listCategory,
      quantity: json['quantity'],
      imageUrl: List<String>.from(json['images'] ?? []),
      price: json['price'],
      color: color,
      condition: json['condition'] ?? '',
    );
  }
}
