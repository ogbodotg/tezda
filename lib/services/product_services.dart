import 'dart:convert';
import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezda/api/auth_data.dart';
import 'package:tezda/helper/utilities.dart';
import 'package:tezda/model/products.dart';
import 'package:tezda/providers/product_provider.dart';

class ProductServices {
  // add products to favourites
  addToFav(Products product, context) async {
    List favProducts = [];
    List fetchedProductIDs = [];

    List fetchedFavProducts = await fetchFavProducts();
    if (fetchedFavProducts.isNotEmpty) {
      for (var i = 0; i < fetchedFavProducts.length; i++) {
        fetchedProductIDs.add(fetchedFavProducts[i]['id']);
      }
      if (fetchedProductIDs.contains(product.id)) {
        showSnackBar(context, "Product already exists in fav list");
      } else {
        var productToJson = product.toJson();

        fetchedFavProducts.add(productToJson);

        await ApiData().saveJsonData(fetchedFavProducts, 'favProduct');
        showSnackBar(context, "Product added to your favourites");
      }
    } else {
      var productToJson = product.toJson();

      favProducts.add(productToJson);

      await ApiData().saveJsonData(favProducts, 'favProduct');
      showSnackBar(context, "Product added to your favourites");
    }
  }

// fetch favourite products
  fetchFavProducts() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    var temp = prefs.getString('favProduct');
    var decodedTemp = jsonDecode(temp.toString()) ?? [];

    return decodedTemp;
  }

// check favourite
  checkFav(productID) async {
    bool? isFavourite;
    List fetchedProductIDs = [];
    List? fetchedFavProducts = await fetchFavProducts();
    if (fetchedFavProducts!.isNotEmpty) {
      for (var i = 0; i < fetchedFavProducts.length; i++) {
        fetchedProductIDs.add(fetchedFavProducts[i]['id']);
      }
      if (fetchedProductIDs.contains(productID)) {
        isFavourite = true;
      } else {
        isFavourite = false;
      }
    }
    return isFavourite;
  }

  // remove products to favourites
  removeFromFav(Products product, context) async {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);

    List? fetchedFavProducts = await fetchFavProducts();
    if (fetchedFavProducts!.isNotEmpty) {
      var index = fetchedFavProducts
          .indexWhere((element) => element['id'] == product.id);

      await fetchedFavProducts.removeAt(index);

      await ApiData().saveJsonData(fetchedFavProducts, 'favProduct');
      productProvider.fetchFavs();
      showSnackBar(context, "Product removed favourites");
    } else {
      showSnackBar(context, "Product not available in fav");
    }
  }
}
