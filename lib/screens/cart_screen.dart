import 'package:ItsOrganic/providers/orders.dart';
import 'package:ItsOrganic/widgets/cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ItsOrganic/providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'My cart',
                  style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              //TODO : add an image in the empty space
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'This is your basket',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          OrderButton(cart: cart),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text('Rs. ${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Colors.orangeAccent,
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.noOfItems,
            itemBuilder: (context, index) => CartWidget(
              id: cart.items.values.toList()[index].id,
              productId: cart.items.keys.toList()[index],
              price: cart.items.values.toList()[index].price,
              quantity: cart.items.values.toList()[index].quantity,
              title: cart.items.values.toList()[index].title,
            ),
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: Colors.lightGreen,
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async{
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                      setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Proceed to checkout  ->',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ));
  }
}
