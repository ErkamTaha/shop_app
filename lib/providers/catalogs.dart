import 'package:flutter/material.dart';
import 'catalog.dart';

class Catalogs with ChangeNotifier {
  List<Catalog> _items = [
    Catalog(
        title: 'Laptops',
        imageUrl:
            'https://media.wired.com/photos/5fb2cc575c9914713ead03de/master/w_1920,c_limit/Gear-Apple-MacBook-Air-top-down-SOURCE-Apple.jpg'),
    Catalog(
        title: 'Phones',
        imageUrl:
            'https://www.apple.com/v/iphone-14-pro/c/images/overview/hero/hero_endframe__dtzvajyextyu_large.jpg'),
    Catalog(
        title: 'Headphones',
        imageUrl:
            'https://www.beatsbydre.com/content/dam/beats/web/product/headphones/studio3-wireless/plp/bbd.plpasset.headphones.studio3-v2.jpg.large.2x.jpg'),
    Catalog(
        title: 'Shoes',
        imageUrl:
            'https://images.squarespace-cdn.com/content/v1/61dcd32b3fb8bb4b5af9b560/1668707748473-KDWCBG5HOQ1XVF5E179L/Allbirds%2BShoes.png'),
    Catalog(
        title: 'Monitors',
        imageUrl:
            'https://dlcdnwebimgs.asus.com/gain/9068EEE1-0424-439D-B86B-3824C18A488E/w750/h470'),
  ];
  List<Catalog> get items {
    return [..._items];
  }
}
