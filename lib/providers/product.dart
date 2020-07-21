import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavourite(String token,String userId) async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = 'https://itsorganic-17149.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try {
      var response = await http.put(url,
          body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        isFavourite = oldstatus;
        notifyListeners();
      }
    } catch (e) {
      isFavourite = oldstatus;
      notifyListeners();
    }
  }
}
