import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/repositories/category_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryCubit(this.categoryRepository) : super(CategoryInitial());

  Future<void> getCategories() async {
    if (state is CategoryLoading) return;
    emit(CategoryLoading());
    try {
      final categories = await categoryRepository.getCategories();
      emit(CategorySuccess(categories));
    } catch (error) {
      emit(CategoryFailure('Failed to load categories: $error'));
    }
  }
}
