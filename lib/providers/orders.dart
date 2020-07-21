import 'dart:convert';

import 'package:ItsOrganic/providers/cart.dart' as crt;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<crt.Cartitem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _order = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this._order , this.userId);
  List<OrderItem> get orders {
    return [..._order];
  }

  Future<void> addOrder(List<crt.Cartitem> cartproducts, double total) async {
    final url =
        'https://itsorganic-17149.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartproducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList()
        }));
    _order.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: cartproducts,
        ));
    notifyListeners();
  }

  Future<void> fetchandSetOrders() async {
    final url =
        'https://itsorganic-17149.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extracted = json.decode(response.body) as Map<String, dynamic>;
    extracted.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => crt.Cartitem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList()));
    });
    _order = loadedOrders.reversed.toList();
    notifyListeners();
  }

  void remove(String productId) {
    _order.remove(productId);
    notifyListeners();
  }
}
