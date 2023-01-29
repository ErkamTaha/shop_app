import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final snackBar = SnackBar(
      content: Text('Added to cart.'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Cancel',
        onPressed: () {
          cart.deleteItem(product.id);
        },
      ),
    );
    return GridTile(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: product.isFavorite
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.outline,
              onPressed: () async {
                try {
                  product.toggleFavoriteStatus(authData.token, authData.userId);
                  await Provider.of<Products>(context, listen: false)
                      .updateProduct(product.id, product);
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
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      footer: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$${product.price.toString()}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
            child: Text(
              'Add To Cart',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              cart.addItem(
                  product.id, product.price, product.title, product.imageUrl);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
    );
  }
}
