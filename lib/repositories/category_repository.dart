import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService = CategoryService();

  Future<List<Category>> getCategories() async {
    return await _categoryService.getCategories();
  }
}
