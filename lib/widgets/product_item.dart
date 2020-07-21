import 'package:ItsOrganic/providers/auth.dart';
import 'package:ItsOrganic/providers/cart.dart';
import 'package:ItsOrganic/providers/product.dart';
import 'package:ItsOrganic/screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String imageurl;
  // final String id;
  // final double price;
  // final String title;
  // ProductItem({this.id, this.imageurl, this.price, this.title});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.fill,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.white54,
          leading: IconButton(
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Colors.orangeAccent,
              ),
              onPressed: () {
                product.toggleFavourite(authData.token,authData.userId);
              }), //wishlist
          trailing: IconButton(
            icon: Icon(Icons.shopping_basket, color: Colors.lightGreen),
            onPressed: () {
              // Cart
              cart.addItems(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item added to your cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ),
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
