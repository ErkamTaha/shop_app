import 'package:flutter/foundation.dart';

class Catalog with ChangeNotifier {
  final String title;
  final String imageUrl;

  Catalog({
    @required this.title,
    @required this.imageUrl,
  });
}
