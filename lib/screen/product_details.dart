import 'package:flutter/material.dart';
import 'package:tezda/model/products.dart';
import 'package:tezda/screen/widgets/expandable_text.dart';
import 'package:tezda/services/product_services.dart';
import 'package:tezda/services/services.dart';
import 'package:tezda/theme/colour.dart';

class ProductDetails extends StatefulWidget {
  static const String routeName = '/product-details-screen';

  final Products product;
  final bool? isFav;
  const ProductDetails({super.key, required this.product, this.isFav});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductServices productServices = ProductServices();
  Services services = Services();
  Products? product;
  num? rate;
  num? count;
  bool isFavourite = false;
  bool isFav = false;
  @override
  void initState() {
    getProductData();
    getFavourite();
    super.initState();
  }

  getProductData() {
    product = widget.product;
    rate = product!.rating!['rate'];
    count = product!.rating!['count'];
    // checkFavourite(product!.id);

    setState(() {});
  }

  getFavourite() {
    isFav = widget.isFav!;
    setState(() {});
  }

  // checkFavourite(productID) async {
  //   isFav = await productServices.checkFav(productID);
  //   log("Favourite is $isFav");
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product!.title!,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Hero(
                    tag: product!.image!,
                    child: services.cachedImage(
                        imageUrl: product!.image, height: 250.0, width: 250.0),
                  ),
                  IconButton(
                      onPressed: () {
                        if (!isFav) {
                          productServices.addToFav(product!, context);

                          setState(() {
                            isFav = true;
                          });
                        } else {
                          productServices.removeFromFav(product!, context);

                          setState(() {
                            isFav = false;
                          });
                        }
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.redAccent,
                        size: isFav ? 50 : 30,
                        weight: 0.5,
                      ))
                ],
              ),
            ),
            services.sizedBox(h: 8),
            Text(
              product!.title!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              services.formatPrice(amount: product!.price, context: context),
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: AppColour.primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    "$rate",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                services.sizedBox(w: 3),
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 18,
                ),
                services.sizedBox(w: 6),
                Text("$count reviews", style: const TextStyle(fontSize: 10))
              ],
            ),
            services.sizedBox(h: 8),
            ExpandableText(
              title: "Product Description",
              content: product!.description!,
            ),
          ],
        ),
      ),
    );
  }
}
