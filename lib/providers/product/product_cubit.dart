import 'package:app_manager/models/product/product.dart';
import 'package:app_manager/repositories/product_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;
  bool isLoadingMore = false;
  int totalPage = 1;
  int currentPage = 1;

  ProductCubit(this.productRepository) : super(ProductInitial());

  Future<void> getProducts() async {
    if (state is ProductLoading ||
        state is ProductLoadingMore ||
        currentPage > totalPage) return;

    if (currentPage == 1) {
      emit(ProductLoading());
    } else {
      isLoadingMore = true;
    }
    try {
      final result = await productRepository.getProducts(page: currentPage);
      final List<Product> products = result['products'];
      totalPage = result['totalPage'];

      if (currentPage == 1) {
        emit(ProductSuccess(products));
      } else {
        print((state as ProductSuccess).products);
        final currentProducts = (state as ProductSuccess).products;
        final newProducts = List<Product>.from(currentProducts)
          ..addAll(products);
        emit(ProductSuccess(newProducts));
      }
      currentPage++;
    } catch (error) {
      emit(ProductFailure('Failed to load products: $error'));
    } finally {
      isLoadingMore = false;
    }
  }
}
