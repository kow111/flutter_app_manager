import 'package:app_manager/models/discount/discount_dto.dart';
import 'package:app_manager/models/discount/discount_model.dart';
import 'package:app_manager/services/discount_service.dart';

class DiscountRepository {
  final DiscountService _discountService = DiscountService();
  Future<Map<String, dynamic>> getDiscounts({int page = 1}) async {
    final result = await _discountService.getDiscounts(page: page);
    return {
      'discounts': result['discounts'] as List<DiscountModel>,
      'totalPage': result['totalPage'] as int,
    };
  }

  Future<bool> addDiscount(DiscountDto data) async {
    return await _discountService.addDiscount(data);
  }
}
