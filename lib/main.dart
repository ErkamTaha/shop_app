import 'package:flutter/material.dart';
import './screens/account_screen.dart';
import './screens/home_screen.dart';
import './screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/catalogs.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/product_in_category_screen.dart';
import 'screens/search_result_screen.dart';
import 'screens/auth_screen.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) => Products(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          update: (context, auth, previous) => Cart(
            auth.token,
            previous == null ? {} : previous.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.orders,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Catalogs(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
            title: 'ShopHeaven',
            theme: FlexThemeData.light(
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },),
              scaffoldBackground: Colors.white,
              scheme: FlexScheme.bigStone,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 9,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 10,
                blendOnColors: false,
                textButtonSchemeColor: SchemeColor.secondary,
                elevatedButtonSchemeColor: SchemeColor.secondary,
                outlinedButtonSchemeColor: SchemeColor.secondary,
                bottomNavigationBarSelectedLabelSchemeColor:
                    SchemeColor.secondary,
                bottomNavigationBarSelectedIconSchemeColor:
                    SchemeColor.secondary,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            themeMode: ThemeMode.system,
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? LoadingScreen()
                            : AuthScreen(),
                  ),
            routes: {
              HomeScreen.routeName: (ctx) => HomeScreen(),
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (cxt) => UserProductsScreen(),
              EditProductScreen.routeName: (cxt) => EditProductScreen(),
              AccountScreen.routeName: (ctx) => AccountScreen(),
              CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
              ProductInCategoryScreen.routeName: (ctx) =>
                  ProductInCategoryScreen(),
              SearchResultScreen.routeName: (ctx) => SearchResultScreen(),
            }),
      ),
    );
  }
}
