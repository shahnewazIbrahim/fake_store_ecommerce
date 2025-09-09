import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/home_banners.dart';

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
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return CustomScrollView(
      key: const PageStorageKey('home_scroll'), // scroll position remember
      slivers: [
        // ---- Categories (horizontal) ----
        SliverToBoxAdapter(
          child: SizedBox(
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
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // ---- Banner slider (scrolls with page) ----
        const SliverToBoxAdapter(child: HomeBanners()),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // ---- Products ----
        if (products.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                childCount: products.length,
              ),
            ),
          ),
      ],
    );
  }
}
