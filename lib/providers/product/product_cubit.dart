import 'dart:io';

import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/models/product/product_model.dart';
import 'package:app_manager/repositories/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;
  bool isLoadingMore = false;
  int _totalPage = 1;
  int _currentPage = 1;

  ProductCubit(this.productRepository) : super(ProductInitial());

  void setTotalPage(int totalPage) {
    _totalPage = totalPage;
  }

  void setCurrentPage(int currentPage) {
    _currentPage = currentPage;
  }

  int get totalPage => _totalPage;

  int get currentPage => _currentPage;

  Future<void> getProducts() async {
    if (state is ProductLoading || isLoadingMore || currentPage > totalPage) {
      return;
    }

    if (currentPage == 1) {
      emit(ProductLoading());
    } else {
      isLoadingMore = true;
    }
    try {
      final result = await productRepository.getProducts(page: currentPage);
      final List<Product> products = result['products'];
      _totalPage = result['totalPage'];

      if (currentPage == 1) {
        emit(ProductSuccess(products));
      } else {
        print((state as ProductSuccess).products);
        final currentProducts = (state as ProductSuccess).products;
        final newProducts = [...currentProducts, ...products];
        emit(ProductSuccess(newProducts));
      }
      _currentPage++;
    } catch (error) {
      emit(ProductFailure('Failed to load products: $error'));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> addProduct(
      String productName,
      String description,
      String size,
      List<Category> category,
      int quantity,
      List<File> images,
      int price,
      String condition,
      String color) async {
    if (state is ProductAddLoading) return;
    emit(ProductAddLoading());
    try {
      final result = await productRepository.addProduct(
        productName,
        description,
        size,
        category,
        quantity,
        images,
        price,
        condition,
        color,
      );
      if (result) {
        emit(ProductAddSuccess());
      } else {
        emit(ProductAddFailure('Failed to add product'));
      }
    } catch (error) {
      emit(ProductAddFailure('Failed to add product: $error'));
    }
  }
}
