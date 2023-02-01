import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

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
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        ProductDetailScreen.routeName,
        arguments: productId,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Card(
          key: ValueKey(productId),
          margin: EdgeInsets.all(4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    color: Colors.white,
                    width: 100,
                    height: 100,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 70,
                        width: 180,
                        child: Text(
                          title,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '\$${(price)}',
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onDoubleTap: () => null,
                      child: IconButton(
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false)
                              .addItem(productId, price, title, imageUrl);
                        },
                        icon: Icon(Icons.add),
                        tooltip: 'Increase amount',
                      ),
                    ),
                    Text('$quantity'),
                    GestureDetector(
                      onDoubleTap: () => null,
                      child: IconButton(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
