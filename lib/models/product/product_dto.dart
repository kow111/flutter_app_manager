class ProductDto {
  final String productName;
  final String description;
  final String size;
  final List<String> category;
  final int quantity;
  final List<String> images;
  final int price;
  final String condition;
  final String color;

  ProductDto({
    required this.productName,
    required this.description,
    required this.size,
    required this.category,
    required this.quantity,
    required this.images,
    required this.price,
    required this.condition,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'description': description,
      'size': size,
      'category': category,
      'quantity': quantity,
      'images': images,
      'price': price,
      'condition': condition,
      'color': color,
    };
  }
}
