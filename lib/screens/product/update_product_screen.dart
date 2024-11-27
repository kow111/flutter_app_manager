import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/models/product/product_model.dart';
import 'package:app_manager/providers/category/category_cubit.dart';
import 'package:app_manager/providers/color/color_cubit.dart';
import 'package:app_manager/providers/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  UpdateProductScreen({required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  String? _selectedCondition;
  String? _selectedSize;
  String? _selectedColorId;
  List<Category> _selectedCategories = [];

  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    context.read<ColorCubit>().getColors();
    context.read<CategoryCubit>().getCategories();

    _nameController = TextEditingController(text: widget.product.productName);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _selectedCondition = widget.product.condition;
    _selectedSize = widget.product.size;
    _selectedColorId = widget.product.color.id;
    _selectedCategories = widget.product.category;
    _images = widget.product.imageUrl;
  }

  void _handleUpdateProduct(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final productName = _nameController.text;
      final description = _descriptionController.text;
      final price = int.parse(_priceController.text);
      final quantity = int.parse(_quantityController.text);
      final size = _selectedSize!;
      final condition = _selectedCondition!;
      final color = _selectedColorId!;
      final categories = _selectedCategories;

      context.read<ProductCubit>().updateProduct(
            widget.product.id,
            productName,
            description,
            size,
            categories,
            quantity,
            price,
            condition,
            color,
          );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cập nhật sản phẩm'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product ID: ${widget.product.id}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                      validator: (value) =>
                          value!.isEmpty ? 'Vui lòng nhập tên sản phẩm' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Mô tả'),
                      validator: (value) =>
                          value!.isEmpty ? 'Vui lòng nhập mô tả' : null,
                    ),
                    TextFormField(
                        controller: _priceController,
                        decoration:
                            InputDecoration(labelText: 'Giá', prefixText: '\$'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập giá';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Vui lòng nhập giá hợp lệ';
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(labelText: 'Số lượng'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số lượng';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Vui lòng nhập số lượng hợp lệ';
                          }
                          return null;
                        }),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Size'),
                      value: _selectedSize,
                      items: ['S', 'M', 'L', 'XL', 'XXL']
                          .map((size) => DropdownMenuItem(
                                value: size,
                                child: Text(size),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _selectedSize = value;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Tình trạng'),
                      value: _selectedCondition,
                      items: ['NEW', '98%', '99%']
                          .map((condition) => DropdownMenuItem(
                                value: condition,
                                child: Text(condition),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _selectedCondition = value;
                      },
                    ),
                    BlocBuilder<ColorCubit, ColorState>(
                        builder: (context, state) {
                      if (state is ColorLoading) {
                        return CircularProgressIndicator();
                      }
                      if (state is ColorSuccess) {
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Màu sắc'),
                          value: _selectedColorId,
                          items: state.colors
                              .map((color) => DropdownMenuItem(
                                    value: color.id,
                                    child: Text(color.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _selectedColorId = value;
                          },
                        );
                      }
                      return Container();
                    }),
                    BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                      if (state is CategoryLoading) {
                        return CircularProgressIndicator();
                      }
                      if (state is CategorySuccess) {
                        return MultiSelectDialogField(
                          items: state.categories
                              .map((category) => MultiSelectItem<Category>(
                                  category, category.name))
                              .toList(),
                          title: Text("Danh mục"),
                          selectedColor: Colors.blue,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          buttonIcon: Icon(
                            Icons.category,
                            color: Colors.blue,
                          ),
                          buttonText: Text(
                            "Chọn danh mục",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onConfirm: (results) {
                            setState(() {
                              // Loại bỏ giá trị trùng lặp bằng cách sử dụng Set
                              _selectedCategories =
                                  results.cast<Category>().toSet().toList();
                            });
                          },
                        );
                      }
                      return Container();
                    }),
                    // ElevatedButton(
                    //   onPressed: _pickImages,
                    //   child: Text('Cập nhật ảnh sản phẩm'),
                    // ),
                    // // Hiển thị ảnh đã chọn
                    _images.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              return Image.network(_images[index]);
                            },
                          )
                        : Container(),

                    SizedBox(height: 20),
                    BlocConsumer<ProductCubit, ProductState>(
                        listener: (context, state) {
                      if (state is ProductUpdateFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      } else if (state is ProductUpdateSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Cập nhật sản phẩm thành công')),
                        );
                        final productCubit = context.read<ProductCubit>();
                        productCubit.setCurrentPage(1);
                        productCubit.getProducts();
                        Navigator.of(context).pop();
                      }
                    }, builder: (context, state) {
                      if (state is ProductUpdateLoading) {
                        return CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () => _handleUpdateProduct(context),
                        child: Text('Cập nhật sản phẩm'),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
