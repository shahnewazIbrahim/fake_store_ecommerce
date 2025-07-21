import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';

  List<Product> get products => _products;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  ProductProvider() {
    fetchCategories();
    fetchAllProducts();
  }

  Future<void> fetchCategories() async {
    try {
      _categories = ['All', ...await ApiService.fetchCategories()];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      _selectedCategory = 'All';
      _products = await ApiService.fetchProducts();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> filterByCategory(String category) async {
    _selectedCategory = category;
    try {
      if (category == 'All') {
        await fetchAllProducts();
      } else {
        _products = await ApiService.fetchProductsByCategory(category);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
