class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: (j['id'] as num).toInt(),
    title: j['title'] ?? '',
    price: (j['price'] as num).toDouble(),
    description: j['description'] ?? '',
    category: j['category'] ?? '',
    image: j['image'] ?? '',
  );
}
