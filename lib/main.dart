import 'package:fake_store_ecommerce/screens/main_shell.dart';
import 'package:flutter/material.dart';
import 'providers/wishlist_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FakeStore',
        theme: AppTheme.light(),
        home: const MainShell(),
      ),
    );
  }
}
