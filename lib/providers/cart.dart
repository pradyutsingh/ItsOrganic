import 'package:flutter/foundation.dart';

class Cartitem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  Cartitem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, Cartitem> _items = {};
  Map<String, Cartitem> get items {
    return {..._items};
  }

  void addItems(String prodId, double price, String title) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (existingItem) => Cartitem(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          prodId,
          () => Cartitem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  int get noOfItems {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, Cartitem) {
      total += Cartitem.price * Cartitem.quantity;
    });
    return total;
  }

  void removeProduct(String Productid) {
    _items.remove(Productid);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (prod) => Cartitem(
              id: prod.id,
              title: prod.title,
              price: prod.price,
              quantity: prod.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
