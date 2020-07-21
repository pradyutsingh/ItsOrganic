import 'package:ItsOrganic/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ItsOrganic/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Orange',
    //   description:
    //       'As with other citrus fruits, orange pulp is an excellent source of vitamin C, providing 64% of the Daily Value in a 100 g serving . Numerous other essential nutrients are present in low amounts',
    //   price: 30,
    //   imageUrl:
    //       'https://image.freepik.com/free-vector/watercolor-orange-background_52683-10330.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Mango',
    //   description: 'Everyones favourite',
    //   price: 50,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/4/40/Mango_4.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Grapes',
    //   description: 'The rainy present for you',
    //   price: 60,
    //   imageUrl:
    //       'https://images.all-free-download.com/images/graphicthumb/table_grapes_grapes_fruit_214430.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Watermelon',
    //   description: 'The tastiest water',
    //   price: 50,
    //   imageUrl:
    //       'https://image.freepik.com/free-photo/watermelon-isolated-white-background_29402-628.jpg',
    // )
  ];

  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get savedItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Future<void> fetchAndSet([bool filter = false]) async {
    String filterString =filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://itsorganic-17149.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://itsorganic-17149.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(url);
      final List<Product> loaderProducts = [];
      final favData = json.decode(favouriteResponse.body);
      extractedData.forEach((prodid, prodData) {
        loaderProducts.add(Product(
            id: prodid,
            title: prodData['title'],
            description: prodData['desciption'],
            price: prodData['price'],
            isFavourite: favData == null ? false : favData['prodid'] ?? false,
            imageUrl: prodData['imageUrl']));
      });
      _items = loaderProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addproduct(Product product) async {
    final url =
        'https://itsorganic-17149.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'desciption': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId
          }));
      final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newprod) async {
    final prodindex = _items.indexWhere((element) => element.id == id);
    if (prodindex >= 0) {
      final url =
          'https://itsorganic-17149.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newprod.title,
            'description': newprod.description,
            'imageUrl': newprod.imageUrl,
            'price': newprod.price,
          }));

      _items[prodindex] = newprod;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteproduct(String id) async {
    //This is called optimistic update - save the index before deleting as if the deletion fails then you have the product
    final url =
        'https://itsorganic-17149.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProdIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);
    _items.removeAt(existingProdIndex);
    notifyListeners();
    if (response.statusCode >= 400) {
      print(response.statusCode);
      _items.insert(existingProdIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
