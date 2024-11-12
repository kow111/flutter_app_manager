import 'package:app_manager/providers/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final productCubit = context.read<ProductCubit>();
    productCubit.setCurrentPage(1);
    productCubit.getProducts();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final productCubit = context.read<ProductCubit>();
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !productCubit.isLoadingMore &&
        productCubit.currentPage <= productCubit.totalPage) {
      productCubit.getProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final productCubit = context.read<ProductCubit>();
              productCubit.setCurrentPage(1);
              productCubit.getProducts();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).pushNamed('/add-product');
              // Gọi lại getProducts sau khi quay lại
              final productCubit = context.read<ProductCubit>();
              productCubit.setCurrentPage(1);
              productCubit.getProducts();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductSuccess) {
            final products = state.products;
            final isLoadingMore = context.read<ProductCubit>().isLoadingMore;

            return ListView.builder(
              itemCount: products.length + 1,
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == products.length) {
                  return isLoadingMore
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                }
                final product = products[index];
                return ListTile(
                  title: Text(product.productName),
                  subtitle: Text(product.description),
                  trailing: Text('\$${product.price}'),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(product.productName),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Categories: ${product.category.map((cat) => cat.name).join(', ')}'),
                            Text('Color: ${product.color.name}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ProductFailure) {
            return Center(child: Text(state.error));
          }
          return Center(child: Text('No products available'));
        },
      ),
    );
  }
}
