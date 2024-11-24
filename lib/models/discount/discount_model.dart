class DiscountModel {
  final String id;
  final String discountCode;
  final int discountPercentage;
  final DateTime? expiredAt;
  final int usageLimit;
  final int usageCount;

  DiscountModel({
    required this.id,
    required this.discountCode,
    required this.discountPercentage,
    required this.expiredAt,
    required this.usageLimit,
    required this.usageCount,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['_id'],
      discountCode: json['discountCode'],
      discountPercentage: json['discountPercentage'],
      expiredAt:
          json['expiredAt'] != null ? DateTime.parse(json['expiredAt']) : null,
      usageLimit: json['usageLimit'] ?? 0,
      usageCount: (json['usersUsed'] as List<dynamic>).length,
    );
  }
}
