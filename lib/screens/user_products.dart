import 'package:ItsOrganic/providers/products_provider.dart';
import 'package:ItsOrganic/screens/edit_product_screen.dart';
import 'package:ItsOrganic/widgets/userproductwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ItsOrganic/providers/product.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'user-product-screen';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context , listen: false).fetchAndSet(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, EditProductScreen.routeName);
        },
      ),
      appBar: AppBar(
        title: const Text('Your Products'),
      ),
      body: FutureBuilder(
              future: _refreshProducts(context),builder: (context,snapshot) =>
              //  snapshot.connectionState == ConnectionState.waiting ? Center(child : CircularProgressIndicator()) ?
           RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                 builder: (context, productData, _) =>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('Your products',
                      style: TextStyle(fontSize: 40, fontFamily: 'Lato')),
              ),
              SizedBox(
                  height: 5,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'This is your own shop ,you can sell your own organic products ,just keep in mind its all organic',
                    softWrap: true,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
              ),
              Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, i) => UserProductitem(
                      id: productData.items[i].id,
                      imageurl: productData.items[i].imageUrl,
                      title: productData.items[i].title,
                    ),
                    itemCount: productData.items.length,
                  ),
              ),
            ],
          ),
                ),
        ),
      ),
    );
  }
}
