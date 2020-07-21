import 'package:ItsOrganic/providers/cart.dart';
import 'package:ItsOrganic/providers/orders.dart';
import 'package:ItsOrganic/screens/edit_product_screen.dart';
import 'package:ItsOrganic/screens/orders_screen.dart';
import 'package:ItsOrganic/screens/product_detail.dart';
import 'package:ItsOrganic/screens/product_overview.dart';
import 'package:ItsOrganic/screens/splash_screen.dart';
import 'package:ItsOrganic/screens/user_products.dart';
import 'package:flutter/material.dart';
import 'providers/products_provider.dart';
import 'package:provider/provider.dart';
import 'screens/cart_screen.dart';
import 'screens/auth_screen.dart';
import 'package:ItsOrganic/providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            // create: (_) => Products(null, [] ,_),
            update: (context, auth, previousProd) => Products(auth.token,
                previousProd == null ? [] : previousProd.items, auth.userId)),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, [], null),
          update: (context, auth, previous) => Orders(auth.token,
              previous.orders == null ? [] : previous.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'ItsOrganic',
          theme: ThemeData(
            primaryColor: Colors.white,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetail.routeName: (context) => ProductDetail(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
