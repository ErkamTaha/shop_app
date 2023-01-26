import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../widgets/products_grid.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
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
              child: products.length>=3 ? Column(
                children: [
                  ImageSlideshow(
                    /// Width of the [ImageSlideshow].
                    width: double.infinity,

                    /// Height of the [ImageSlideshow].
                    height: 300,

                    /// The page to show when first creating the [ImageSlideshow].
                    initialPage: 0,

                    /// The color to paint the indicator.
                    indicatorColor: Colors.blue,

                    /// The color to paint behind th indicator.
                    indicatorBackgroundColor: Colors.grey,

                    /// The widgets to display in the [ImageSlideshow].
                    /// Add the sample image file into the images folder
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
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
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
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
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
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
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
                    ],

                    /// Called whenever the page in the center of the viewport changes.
                    onPageChanged: (value) {
                      //print('Page changed: $value');
                    },

                    /// Auto scroll interval.
                    /// Do not auto scroll with null or 0.
                    autoPlayInterval: 3000,

                    /// Loops back to first slide.
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
