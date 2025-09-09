import 'package:fakestore_modern/widgets/product_card.dart';
import 'package:fakestore_modern/features/catalog/providers/cart_provider.dart';
import 'package:fakestore_modern/features/catalog/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final productProvider = context.watch<ProductProvider>();
    final cart = context.read<CartProvider>();

    if (productProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productProvider.categories.length,
            itemBuilder: (context, index) {
              final category = productProvider.categories[index];
              final isSelected = category == productProvider.selectedCategory;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => productProvider.filterByCategory(category),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            key: const PageStorageKey('home_grid'),
            padding: const EdgeInsets.all(8),
            itemCount: productProvider.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 260,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductCard(
                product: product,
                onAddToCart: () => cart.add(product),
              );
            },
          ),
        ),
      ],
    );
  }
}
