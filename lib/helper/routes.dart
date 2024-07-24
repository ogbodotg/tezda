import 'package:flutter/material.dart';
import 'package:tezda/auth/auth_screen.dart';
import 'package:tezda/model/products.dart';
import 'package:tezda/screen/home.dart';
import 'package:tezda/screen/product_details.dart';
import 'package:tezda/screen/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SplashScreen(),
      );
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case ProductDetails.routeName:
      Products product = routeSettings.arguments as Products;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetails(
          product: product,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(18),
            child: Center(
              child: Text(
                  'Unknown route (404): We could not find the page you\'re looking for'),
            ),
          ),
        ),
      );
  }
}
