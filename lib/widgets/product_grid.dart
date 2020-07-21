import 'package:ItsOrganic/providers/product.dart';
import 'package:ItsOrganic/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:ItsOrganic/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavourites;
  ProductGrid(this.showFavourites);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavourites ? productData.savedItems : productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(
                  // id: products[i].id,
                  // price: products[i].price,
                  // imageurl: products[i].imageUrl,
                  // title: products[i].title,
                  ),
            ));
  }
}
