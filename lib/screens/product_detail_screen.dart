import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../providers/auth.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final authData = Provider.of<Auth>(context, listen: false);
    final loadedProduct = Provider.of<Products>(
      context,
    ).findById(productId);
    final productTitle = loadedProduct.title;
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            expandedHeight: 450,
            collapsedHeight: 100,
            actions: [
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
                    loadedProduct.toggleFavoriteStatus(
                        authData.token, authData.userId);
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
            ],
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productTitle.length > 150 ? '${productTitle.substring(0, 150)}...' : productTitle,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, overflow: TextOverflow.fade),
                ),
              ),
              background: Padding(
                padding: EdgeInsets.all(64),
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Text(
                              '\$${loadedProduct.price}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 24,
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
                        height: 600,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: SizedBox(
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
      ),
    );
  }
}
