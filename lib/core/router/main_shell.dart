import 'package:fakestore_modern/features/account/ui/account_tab.dart';
import 'package:fakestore_modern/features/catalog/ui/home/cart_tab.dart';
import 'package:fakestore_modern/features/catalog/ui/home/home_tab.dart';
import 'package:fakestore_modern/features/wishlist/ui/wishlist_tab.dart';
import 'package:fakestore_modern/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  static const _titles = ['FakeStore', 'Your Cart', 'Wishlist', 'Account'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.gradientTeal,
            ),
          ),
        ),
        actions: _index == 1
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => setState(() => _index = 1),
                )
              ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          HomeTab(),
          CartTab(),
          WishlistTab(),
          AccountTab(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
