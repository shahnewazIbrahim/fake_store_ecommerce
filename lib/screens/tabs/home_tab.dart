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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return CustomScrollView(
      key: const PageStorageKey('home_scroll'), // scroll position remember
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Curated picks, trending now, just for you.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onBackground.withOpacity(.7),
                  ),
                ),
                const SizedBox(height: 12),
                const _SearchBar(),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: _SectionHeader(title: 'Shop by category'),
        ),

        // ---- Categories (horizontal) ----
        SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    showCheckmark: false,
                    selectedColor: scheme.primary,
                    backgroundColor: Colors.white,
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected ? Colors.white : scheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => productProvider.filterByCategory(category),
                  ),
                );
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        const SliverToBoxAdapter(
          child: _SectionHeader(
            title: 'Featured picks',
            actionText: 'See all',
          ),
        ),

        // ---- Banner slider (scrolls with page) ----
        const SliverToBoxAdapter(child: HomeBanners()),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        const SliverToBoxAdapter(
          child: _SectionHeader(title: 'Popular right now'),
        ),

        // ---- Products ----
        if (products.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;

  const _SectionHeader({required this.title, this.actionText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (actionText != null)
            Text(
              actionText!,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search products, brands, categories',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.tune, color: Colors.white),
        ),
      ),
      onSubmitted: (_) {},
    );
  }
}
