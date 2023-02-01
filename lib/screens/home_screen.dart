import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../widgets/products_grid.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
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
    final products = Provider.of<Products>(context).items;
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: products.length >= 3
                  ? Column(
                      children: [
                        ImageSlideshow(
                          width: double.infinity,
                          height: 300,
                          initialPage: 0,
                          indicatorColor: Theme.of(context).colorScheme.secondary,
                          indicatorBackgroundColor: Colors.grey,
                          children: [
                            GridTile(
                              footer: Container(
                                height: 60,
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    products[0].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(64),
                                child: ChangeNotifierProvider.value(
                                  value: products[0],
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routeName,
                                        arguments: products[0].id,
                                      );
                                    },
                                    child: Image.network(
                                      products[0].imageUrl,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GridTile(
                              footer: Container(
                                height: 60,
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    products[1].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(64),
                                child: ChangeNotifierProvider.value(
                                  value: products[1],
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routeName,
                                        arguments: products[1].id,
                                      );
                                    },
                                    child: Image.network(
                                      products[1].imageUrl,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GridTile(
                              footer: Container(
                                height: 60,
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    products[2].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(64),
                                child: ChangeNotifierProvider.value(
                                  value: products[2],
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        ProductDetailScreen.routeName,
                                        arguments: products[2].id,
                                      );
                                    },
                                    child: Image.network(
                                      products[2].imageUrl,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          onPageChanged: (value) {
                          },
                          autoPlayInterval: 4000,
                          isLoop: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ProductsGrid(false),
                      ],
                    )
                  : ProductsGrid(false),
            ),
    );
  }
}
