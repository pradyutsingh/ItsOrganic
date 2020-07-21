import 'package:ItsOrganic/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  // String title;
  // ProductDetail(this.title);
  static const routeName = 'product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        //TODO : add to cart from this one
      },
      child: Icon(Icons.add , color: Colors.white,),
      backgroundColor: Colors.orangeAccent,
      ),
      appBar: AppBar(
        title: Text(loadedProduct.title , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                border: Border.all(color: Colors.orangeAccent , width: 30),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
              ),
              height: 300,
              width: double.infinity,
              child: Image.network(loadedProduct.imageUrl , fit: BoxFit.cover,),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'Rs. ${loadedProduct.price}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
          
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30 ,right: 30),
              child: Text(
                '${loadedProduct.description}',
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                  color:Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
            

          ],
        ),
      ),

    );
  }
}
