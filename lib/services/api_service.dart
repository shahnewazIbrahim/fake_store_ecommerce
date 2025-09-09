import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/banner_item.dart';
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  static Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((cat) => cat.toString()).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  static Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$category'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load category products");
    }
  }

  static Future<List<BannerItem>> fetchBanners({int limit = 6}) async {
    final resp = await http.get(Uri.parse('$baseUrl?limit=$limit&sort=desc'));
    if (resp.statusCode != 200) {
      throw Exception('Failed to load banners');
    }
    final List list = jsonDecode(resp.body);
    // কিছুটা শাফল করে নিলাম যেন ভ্যারাইটি আসে
    list.shuffle(Random());

    return list.map((item) {
      final rawId = item['id'];
      final int id = rawId is int
          ? rawId
          : (rawId is num ? rawId.toInt() : int.tryParse('$rawId') ?? -1);

      return BannerItem(
        productId: id,
        image: '${item['image'] ?? ''}',
        title: '${item['title'] ?? ''}',
      );
    }).where((b) => b.productId > 0 && b.image.isNotEmpty).toList();
  }
}
