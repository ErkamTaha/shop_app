import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/account_screen.dart';
import 'package:provider/provider.dart';
import '../models/CustomSearchDelegate.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  int _selectedIndex = 0;
  final _buildBody = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Cart>(context).fetchCartItems();
      Provider.of<Products>(context).fetchProducts().then(((value) {
        setState(() {
          _isLoading = false;
        });
      }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop Heaven',
        ),
        leading: Icon(Icons.shop),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AccountScreen.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : IndexedStack(
              index: _selectedIndex,
              children: _buildBody,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
