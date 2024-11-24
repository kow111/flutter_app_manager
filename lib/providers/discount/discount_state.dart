part of 'discount_cubit.dart';

@immutable
sealed class DiscountState {}

final class DiscountInitial extends DiscountState {}

final class DiscountLoading extends DiscountState {}

final class DiscountLoaded extends DiscountState {
  final List<DiscountModel> discounts;
  final int totalPage;

  DiscountLoaded({
    required this.discounts,
    required this.totalPage,
  });
}

final class DiscountFailure extends DiscountState {
  final String error;

  DiscountFailure(this.error);
}
