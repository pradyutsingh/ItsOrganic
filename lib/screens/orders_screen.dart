import 'package:ItsOrganic/widgets/app_drawer.dart';
import 'package:ItsOrganic/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ItsOrganic/providers/orders.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context, listen: false).fetchandSetOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('Your Orders...',
                style: TextStyle(fontSize: 40, fontFamily: 'Lato')),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Check what you previouly ordered',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, i) => OrderWidget(orderData.orders[i])),
          )
        ],
      ),
    );
  }
}
