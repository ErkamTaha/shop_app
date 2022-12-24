import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  UserProductItem(
    this.id,
    this.title,
    this.price,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Removing ${(title)}'),
                        content: Text('Are you sure?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                await Provider.of<Products>(context,
                                        listen: false)
                                    .deleteProduct(id);
                              } catch (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'The product could not be deleted.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
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
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
