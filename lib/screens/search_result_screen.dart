import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/products_grid_category.dart';
import 'package:flutter_complete_guide/widgets/search_result_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class SearchResultScreen extends StatefulWidget {
  static const routeName = '/search-result';
  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
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
    final search = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "${search}": '),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SearchResultGrid(search),
                ],
              ),
            ),
    );
  }
}
