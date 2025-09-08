import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import '../widgets/app_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("FakeStore"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.teal.shade800,
                  Colors.teal.shade600,
                  Colors.teal.shade400,
                ],
              ),
            ),
          ),
        ),

        // ── Body with tabs ────────────────────────────────────────────────
        body: IndexedStack(
          index: _index,
          children: [
            // Home
            Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = productProvider.categories[index];
                      final isSelected =
                          category == productProvider.selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (_) =>
                              productProvider.filterByCategory(category),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: productProvider.products.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: productProvider.products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 250,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final product = productProvider.products[index];
                              return ProductCard(product: product);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),

        // ── iOS-like Bottom Navigation ────────────────────────────────────
        bottomNavigationBar: AppBottomNav(
          currentIndex: _index,
          onTap: (i) {
            switch (i) {
              case 0:
                // ✅ Home এ নিন (stack পরিষ্কার করে)
                // যদি named route না থাকে, এই দুই লাইনে কাজ সারুন:
                Navigator.of(context).popUntil((r) => r.isFirst);
                setState(() => _index = 0);
                break;

              case 1:
                // ✅ CartScreen এ যান (নতুন পেজ)
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
                break;

              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon')),
                );
            }
          },
        ));
  }
}
