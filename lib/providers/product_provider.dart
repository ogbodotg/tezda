import 'package:flutter/material.dart';
import 'package:tezda/services/product_services.dart';

class ProductProvider extends ChangeNotifier {
  ProductServices productServices = ProductServices();
  List favouriteProducts = [];

  // fetch favourites
  fetchFavs() async {
    favouriteProducts = await productServices.fetchFavProducts();
    notifyListeners();
  }
}
