import 'dart:io';

import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/providers/category/category_cubit.dart';
import 'package:app_manager/providers/color/color_cubit.dart';
import 'package:app_manager/providers/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _quantityController = TextEditingController();

  String? _selectedCondition;

  String? _selectedSize;

  String? _selectedColorId;

  List<Category> _selectedCategories = [];

  List<File> _images = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ColorCubit>().getColors();
    context.read<CategoryCubit>().getCategories();
    _selectedCondition = 'NEW';
    _selectedSize = 'S';
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(); // Allow multiple images
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  void _handleAddProduct(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final productName = _nameController.text;
      final description = _descriptionController.text;
      final price = int.parse(_priceController.text);
      final quantity = int.parse(_quantityController.text);
      final size = _selectedSize!;
      final condition = _selectedCondition!;
      final color = _selectedColorId!;
      final category = _selectedCategories;
      context.read<ProductCubit>().addProduct(
            productName,
            description,
            size,
            category,
            quantity,
            _images,
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
          title: Text('Thêm sản phẩm mới'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
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
                  validator: (value) =>
                      value == null ? 'Vui lòng chọn Size' : null,
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
                  validator: (value) =>
                      value == null ? 'Vui lòng chọn tình trạng' : null,
                ),
                BlocBuilder<ColorCubit, ColorState>(builder: (context, state) {
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
                      validator: (value) =>
                          value == null ? 'Vui lòng chọn màu sắc' : null,
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
                          _selectedCategories = results.cast<Category>();
                        });
                      },
                    );
                  }
                  return Container();
                }),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: Text('Chọn ảnh sản phẩm'),
                ),
                // Display selected images
                _images.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Image.file(_images[index]);
                        },
                      )
                    : Container(),
                SizedBox(height: 20),
                BlocConsumer<ProductCubit, ProductState>(
                    listener: (context, state) {
                  if (state is ProductAddFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  } else if (state is ProductAddSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thêm sản phẩm thành công')),
                    );
                    Navigator.of(context).pop();
                  }
                }, builder: (context, state) {
                  if (state is ProductAddLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () => _handleAddProduct(context),
                    child: Text('Thêm sản phẩm'),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
