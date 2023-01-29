import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
 
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  String categoryId;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.categoryId,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
    await http.put(url,
        body: json.encode(
          isFavorite,
        ));
  }
}
