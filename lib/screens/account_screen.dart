import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'orders_screen.dart';
import 'user_products_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key key}) : super(key: key);
  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('My Products'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductsScreen.routeName).whenComplete(() => Provider.of<Products>(context, listen: false).fetchProducts(),);
            },
          ),
        ],
      ),
    );
  }
}
