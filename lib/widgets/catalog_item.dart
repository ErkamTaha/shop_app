import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalog.dart';
import '../screens/product_in_category_screen.dart';

class CatalogItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final catalog = Provider.of<Catalog>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductInCategoryScreen.routeName,
              arguments: catalog.title,
            );
          },
          child: Image.network(
            catalog.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              catalog.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
