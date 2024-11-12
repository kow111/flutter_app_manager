part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final List<Category> categories;

  CategorySuccess(this.categories);
}

final class CategoryFailure extends CategoryState {
  final String error;

  CategoryFailure(this.error);
}
