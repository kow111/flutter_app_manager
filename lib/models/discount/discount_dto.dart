class DiscountDto {
  final String discountCode;
  final int discountPercentage;
  final DateTime? expiredAt;
  final int? usageLimit;

  DiscountDto({
    required this.discountCode,
    required this.discountPercentage,
    required this.expiredAt,
    required this.usageLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      'discountCode': discountCode,
      'discountPercentage': discountPercentage,
      'expiredAt': expiredAt,
      'usageLimit': usageLimit,
    };
  }
}
