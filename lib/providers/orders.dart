import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_time_patterns.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  /*Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData != null) {
        extractedData.forEach((id, cartItemData) {
          _orders.add(OrderItem(
                  id: id,
                  amount: cartItemData['amount'],
                  products: cartItemData['products'],
                  dateTime: cartItemData['dateTime'],
                )
          );
        });
      }
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }*/

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-f3683-default-rtdb.firebaseio.com/orders.json');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'products': cartProducts.map((e) => {
            'id': e.id,
            'productId': e.productId,
            'title': e.title,
            'quantity': e.quantity,
            'price': e.price,
            'imageUrl': e.imageUrl,
          }).toList(),
          'dateTime': timestamp.toIso8601String(),
        }),
      );
      final newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      );
      _orders.add(newOrder);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
