import 'package:flutter/material.dart';
import 'package:gemicates/providers/user_provider.dart';
import 'package:gemicates/views/auth/login_page.dart';
import 'package:gemicates/views/common/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import 'product_tile.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchRemoteConfig();
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  void _logOut() {
    Provider.of<UserProvider>(context, listen: false).signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () {
                _logOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          if (productProvider.products.isEmpty) {
            return const Center(child: Loader());
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 0.7,
            ),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductTile(product: product);
            },
          );
        },
      ),
    );
  }
}
