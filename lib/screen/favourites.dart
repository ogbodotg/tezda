import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezda/model/products.dart';
import 'package:tezda/providers/product_provider.dart';
import 'package:tezda/screen/widgets/product_card.dart';
import 'package:tezda/services/product_services.dart';
import 'package:tezda/services/services.dart';

class Favourites extends StatefulWidget {
  static const String routeName = '/favourites-screen';

  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  Services services = Services();
  ProductServices productServices = ProductServices();
  List products = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    productProvider.fetchFavs();

    products = productProvider.favouriteProducts;
    setState(() {});

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: services.appBar(showBackButton: false, context: context),
      body: loading
          ? Center(
              child: services.showLoader(40),
            )
          : products.isNotEmpty
              ? GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: List.generate(products.length, (index) {
                    Products product = Products.fromJson(products[index]);

                    return ProductCard(product: product);
                  }),
                )
              : const Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text("You have no product in your favourite list",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                ),
    );
  }
}
