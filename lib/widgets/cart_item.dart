import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  CartItem(
    this.productId,
    this.price,
    this.quantity,
    this.title,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final lastItem =
        Provider.of<Cart>(context, listen: false).lastItem(productId);
    return Card(
      key: ValueKey(productId),
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                ),
                Text(
                  '\$${(price)}',
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .addItem(productId, price, title, imageUrl);
                  },
                  icon: Icon(Icons.add),
                  tooltip: 'Increase amount',
                ),
                Text('$quantity'),
                IconButton(
                  onPressed: () {
                    if (lastItem) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Removing ${(title)}'),
                          content: Text('Are you sure?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<Cart>(context, listen: false)
                                    .deleteItem(productId);
                                Navigator.pop(context);
                              },
                              child: Text('Yes'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      Provider.of<Cart>(context, listen: false)
                          .deleteItem(productId);
                    }
                  },
                  icon: Icon(Icons.remove),
                  tooltip: 'Decrease amount',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
