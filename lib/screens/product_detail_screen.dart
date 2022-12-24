import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
    ).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    final snackBar = SnackBar(
      content: Text('Added to cart.'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Cancel',
        onPressed: () {
          cart.deleteItem(loadedProduct.id);
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.scaleDown,
            ),
          ),
          Text(
            '${loadedProduct.title}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    loadedProduct.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  color: loadedProduct.isFavorite
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.outline,
                  onPressed: () async {
                    try {
                      loadedProduct.toggleFavoriteStatus();
                      await Provider.of<Products>(context, listen: false)
                          .updateProduct(loadedProduct.id, loadedProduct);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Could not add to favorites.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                ),
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 250,
            width: double.infinity,
            child: Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              child: Text(
                'Add To Cart',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
              onPressed: () {
                cart.addItem(loadedProduct.id, loadedProduct.price,
                    loadedProduct.title, loadedProduct.imageUrl);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
    );
  }
}
