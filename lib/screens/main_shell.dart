import 'package:fake_store_ecommerce/screens/tabs/account_tab.dart';
import 'package:fake_store_ecommerce/screens/tabs/wishlist_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_bottom_nav.dart';
import 'tabs/home_tab.dart';
import 'tabs/cart_tab.dart';

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
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: _index == 1
            ? [] // Cart ট্যাবে কার্ট বাটন দেখানোর দরকার নেই
            : [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => setState(() => _index = 1),
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

      // body শুধু বদলাবে, state টিকে থাকবে
      body: IndexedStack(
        index: _index,
        children: const [
          HomeTab(), // 0
          CartTab(), // 1
          WishlistTab(), // 2
          AccountTab(), // 3
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String text;

  const _Placeholder(this.text);

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(text, style: const TextStyle(fontSize: 16)));
}
