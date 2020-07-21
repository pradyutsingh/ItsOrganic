import 'package:ItsOrganic/providers/cart.dart';
import 'package:ItsOrganic/providers/products_provider.dart';
import 'package:ItsOrganic/screens/cart_screen.dart';
import 'package:ItsOrganic/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ItsOrganic/providers/product.dart';
import 'package:ItsOrganic/widgets/product_grid.dart';
import 'package:ItsOrganic/widgets/badge.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Saved, All, Logout }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _isInit = true;
  bool _showsaved = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
      _isLoading = true;
        
      });
      Provider.of<Products>(context).fetchAndSet().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedvalue) {
                setState(() {
                  if (selectedvalue == FilterOptions.Saved) {
                    _showsaved = true;
                  } else {
                    _showsaved = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Your wishlist'),
                  value: FilterOptions.Saved,
                ),
                PopupMenuItem(
                  child: Text('All products'),
                  value: FilterOptions.All,
                ),
                
              ],
            ),
            Consumer<Cart>(
              builder: (_, value, ch) => Badge(
                child: ch,
                value: cart.noOfItems.toString(),
              ),
              //this is the child of consumer which need to be passed through the provider and then rendered
              //only when needed ,decreasing the overall computation .In this ,child is being passed as reference
              //named ch to avoid confusion.
              child: IconButton(
                  icon: Icon(Icons.shopping_basket),
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  }),
            )
          ],
          backgroundColor: Colors.white,
          title: Text(
            'Our products',
            style: TextStyle(color: Colors.black),
          ),
        ),
        drawer: AppDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Hey,',
                  style: TextStyle(fontSize: 40, fontFamily: 'Lato')),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Choose from this wide collection of organic products from various kitchen gardens of your city',
                softWrap: true,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            Expanded(
              child:  ProductGrid(_showsaved),
            ),
          ],
        ));
  }
}
