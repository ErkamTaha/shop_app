import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key key}) : super(key: key);
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: (() => _refreshProducts(context)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => UserProductItem(
              productsData.items[i].id,
              productsData.items[i].title,
              productsData.items[i].price,
              productsData.items[i].imageUrl,
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
