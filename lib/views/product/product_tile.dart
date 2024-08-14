import 'package:flutter/material.dart';
import 'package:gemicates/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    bool showDiscountedPrice =
        Provider.of<ProductProvider>(context).showDiscountedPrice;

    double displayedPrice = showDiscountedPrice
        ? product.price * (1 - product.discountPercentage / 100)
        : product.price;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: ColorsConst.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: ColorsConst.shadow,
            blurRadius: 4,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(product.thumbnail),
          Text(product.title),
          Text('Rs. ${displayedPrice.toStringAsFixed(2)}')
        ],
      ),
    );
  }
}
