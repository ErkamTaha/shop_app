import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/products_grid_category.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductInCategoryScreen extends StatefulWidget {
  static const routeName = '/product-in-category';
  @override
  _ProductInCategoryState createState() => _ProductInCategoryState();
}

class _ProductInCategoryState extends State<ProductInCategoryScreen> {
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
    final categoryId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryId),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ProductsGridCategory(categoryId),
                ],
              ),
            ),
    );
  }
}
