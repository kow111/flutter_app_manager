import 'package:app_manager/models/discount/discount_model.dart';
import 'package:app_manager/repositories/discount_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'discount_state.dart';

class DiscountCubit extends Cubit<DiscountState> {
  final DiscountRepository discountRepository;
  bool isLoadingMore = false;
  int _totalPage = 1;
  int _currentPage = 1;
  DiscountCubit(this.discountRepository) : super(DiscountInitial());

  void setTotalPage(int totalPage) {
    _totalPage = totalPage;
  }

  void setCurrentPage(int currentPage) {
    _currentPage = currentPage;
  }

  int get totalPage => _totalPage;

  int get currentPage => _currentPage;

  Future<void> getDiscounts() async {
    if (state is DiscountLoading || isLoadingMore || currentPage > totalPage) {
      return;
    }

    if (currentPage == 1) {
      emit(DiscountLoading());
    } else {
      isLoadingMore = true;
    }
    try {
      final result = await discountRepository.getDiscounts(page: currentPage);
      final List<DiscountModel> discounts = result['discounts'];
      _totalPage = result['totalPage'];

      if (currentPage == 1) {
        emit(DiscountLoaded(discounts: discounts, totalPage: _totalPage));
      } else {
        final currentDiscounts = (state as DiscountLoaded).discounts;
        final newDiscounts = [...currentDiscounts, ...discounts];
        emit(DiscountLoaded(discounts: newDiscounts, totalPage: _totalPage));
      }
      _currentPage++;
    } catch (error) {
      emit(DiscountFailure('Failed to load discounts: $error'));
    } finally {
      isLoadingMore = false;
    }
  }
}
