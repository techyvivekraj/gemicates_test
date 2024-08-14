import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../controllers/product_controller.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _showDiscountedPrice = false;
  final ProductController _productController = ProductController();

  List<Product> get products => _products;

  bool get showDiscountedPrice => _showDiscountedPrice;

  Future<void> fetchProducts() async {
    try {
      _products = await _productController.fetchProducts();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> fetchRemoteConfig() async {
    try {
      _showDiscountedPrice = await _productController.fetchRemoteConfig();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch remote config: $e');
    }
  }
}
