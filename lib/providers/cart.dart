import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'products.dart';
import 'package:provider/provider.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> fetchCartItems() async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/cart-items.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData != null) {
        extractedData.forEach((id, cartItemData) {
          _items.putIfAbsent(
            cartItemData['productId'],
            (() => CartItem(
                  id: id,
                  productId: cartItemData['productId'],
                  title: cartItemData['title'],
                  quantity: cartItemData['quantity'],
                  price: cartItemData['price'],
                  imageUrl: cartItemData['imageUrl'],
                )),
          );
        });
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> increaseQuantity(id, productId) async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/cart-items/$id.json');
    try {
      await http.patch(
        url,
        body: json.encode({
          'quantity': _items[productId].quantity + 1,
        }),
      );
    } catch (error) {
      throw error;
    }
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        productId: existingCartItem.productId,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
        imageUrl: existingCartItem.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> addNewItem(productId, title, price, imageUrl) async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/cart-items.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'productId': productId,
          'title': title,
          'price': price,
          'quantity': 1,
          'imageUrl': imageUrl,
        }),
      );
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: json.decode(response.body)['name'],
          productId: productId,
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> decreaseQuantity(id, productId) async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/cart-items/$id.json');
    try {
      await http.patch(
        url,
        body: json.encode({
          'quantity': _items[productId].quantity - 1,
        }),
      );
    } catch (error) {
      throw error;
    }
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        productId: existingCartItem.productId,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity - 1,
        imageUrl: existingCartItem.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> removeItem(id, productId) async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/cart-items/$id.json');
    try {
      await http.delete(url);
    } catch (error) {
      throw error;
    }
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      increaseQuantity(_items[productId].id, productId);
    } else {
      addNewItem(productId, title, price, imageUrl);
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      decreaseQuantity(_items[productId].id, productId);
    } else {
      removeItem(_items[productId].id, productId);
    }
    notifyListeners();
  }

  /*void clear() {
    _items = {};
    notifyListeners();
  }*/

  Future<void> clear() async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/cart-items.json');
    try {
      await http.delete(url);
      _items.clear();
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  bool lastItem(String productId) {
    if (_items[productId].quantity == 1) {
      return true;
    } else {
      return false;
    }
  }
}
