import 'dart:io';

import 'package:app_manager/models/category/category.dart';
import 'package:app_manager/models/product/product_model.dart';
import 'package:app_manager/models/product/product_dto.dart';
import 'package:app_manager/services/product_service.dart';
import 'package:app_manager/services/upload_service.dart';

class ProductRepository {
  final ProductService _productService = ProductService();
  final UploadService _uploadService = UploadService();
  Future<Map<String, dynamic>> getProducts({int page = 1}) async {
    final result = await _productService.getProducts(page: page);
    return {
      'products': result['products'] as List<Product>,
      'totalPage': result['totalPage'] as int,
    };
  }

  Future<bool> addProduct(
      String productName,
      String description,
      String size,
      List<Category> category,
      int quantity,
      List<File> images,
      int price,
      String condition,
      String color) async {
    List<String> listCateId = [];
    List<String> listImages = [];
    for (var element in category) {
      listCateId.add(element.id);
    }
    for (var file in images) {
      final link = await _uploadService.uploadImage(file);
      listImages.add(link);
    }
    final product = ProductDto(
      productName: productName,
      description: description,
      size: size,
      category: listCateId,
      quantity: quantity,
      images: listImages,
      price: price,
      condition: condition,
      color: color,
    );

    return await _productService.addProduct(product);
  }

  Future<bool> updateProduct(
      String id,
      String productName,
      String description,
      String size,
      List<Category> category,
      int quantity,
      // List<Object> actionImages,
      int price,
      String condition,
      String color) async {
    List<String> listCateId = [];
    List<String> listImages = [];
    for (var element in category) {
      listCateId.add(element.id);
    }
    final product = ProductDto(
      productName: productName,
      description: description,
      size: size,
      category: listCateId,
      quantity: quantity,
      images: listImages,
      price: price,
      condition: condition,
      color: color,
    );

    return await _productService.updateProduct(id, product);
  }
}
