import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalogs.dart';
import 'catalog_item.dart';

class CategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final catalogs = Provider.of<Catalogs>(context).items;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10.0),
      itemCount: catalogs.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: catalogs[i],
        child: CatalogItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
