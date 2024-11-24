import 'package:app_manager/providers/discount/discount_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountScreen extends StatefulWidget {
  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final discountCubit = context.read<DiscountCubit>();
    discountCubit.setCurrentPage(1);
    discountCubit.getDiscounts();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final discountCubit = context.read<DiscountCubit>();
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !discountCubit.isLoadingMore &&
        discountCubit.currentPage <= discountCubit.totalPage) {
      discountCubit.getDiscounts();
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
        title: Text('Discounts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final discountCubit = context.read<DiscountCubit>();
              discountCubit.setCurrentPage(1);
              discountCubit.getDiscounts();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).pushNamed('/add-discount');
              // Gọi lại getDiscounts sau khi quay lại
              final discountCubit = context.read<DiscountCubit>();
              discountCubit.setCurrentPage(1);
              discountCubit.getDiscounts();
            },
          ),
        ],
      ),
      body: BlocBuilder<DiscountCubit, DiscountState>(
        builder: (context, state) {
          if (state is DiscountLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DiscountLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.discounts.length + 1,
              itemBuilder: (context, index) {
                if (index < state.discounts.length) {
                  final discount = state.discounts[index];
                  return ListTile(
                    title: Text(discount.discountCode),
                    subtitle: discount.expiredAt != null
                        ? Text('Expired at: ${discount.expiredAt}')
                        : null,
                    trailing: Text('${discount.discountPercentage}%'),
                  );
                } else {
                  if (context.read<DiscountCubit>().isLoadingMore) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                }
              },
            );
          } else if (state is DiscountFailure) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
