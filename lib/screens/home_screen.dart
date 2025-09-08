import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("FakeStore"),
        // backgroundColor: Colors.teal[600],
        // foregroundColor: Colors.white, // <- makes icons/text visible
        foregroundColor: Colors.white,
        // টেক্সট/আইকন সাদা
        backgroundColor: Colors.transparent,
        // gradient দেখাতে transparent
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        // M3 overlay সরালাম
        systemOverlayStyle: SystemUiOverlayStyle.light,
        // status bar আইকন সাদা
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen()));
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
        )),
      ),
      body: Column(
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
                    onSelected: (_) {
                      productProvider.filterByCategory(category);
                    },
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

    );
  }
}
