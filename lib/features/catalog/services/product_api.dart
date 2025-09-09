import 'dart:convert';

import 'package:fakestore_modern/features/cart/models/product.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

abstract class ProductSource {
  Future<List<Product>> fetchProducts();
}

// Public fake API
class FakeStoreApi implements ProductSource {
  @override
  Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (res.statusCode == 200) {
      final list = json.decode(res.body) as List;
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }
}

// Offline mock (assets)
class MockProductApi implements ProductSource {
  @override
  Future<List<Product>> fetchProducts() async {
    final raw = await rootBundle.loadString('assets/mock/products.json');
    final list = json.decode(raw) as List;
    return list.map((e) => Product.fromJson(e)).toList();
  }
}
