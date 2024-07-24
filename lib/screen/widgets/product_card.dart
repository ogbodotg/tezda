import 'package:flutter/material.dart';
import 'package:tezda/model/products.dart';
import 'package:tezda/screen/product_details.dart';
import 'package:tezda/services/product_services.dart';
import 'package:tezda/services/services.dart';
import 'package:tezda/theme/colour.dart';

class ProductCard extends StatefulWidget {
  final Products? product;
  const ProductCard({super.key, this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Services services = Services();
  ProductServices productServices = ProductServices();
  Products? product;
  num? rate;
  num? count;
  bool isFav = false;

  @override
  void initState() {
    fetchProductData();
    super.initState();
  }

  fetchProductData() {
    if (widget.product != null) {
      product = widget.product;
      rate = product!.rating!['rate'];
      count = product!.rating!['count'];
      checkFavourite(product!.id);
    }
    setState(() {});
  }

  checkFavourite(productID) async {
    isFav = await productServices.checkFav(productID);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: const Duration(seconds: 1),
                    pageBuilder: (context, __, ___) {
                      return ProductDetails(
                        product: product!,
                        isFav: isFav,
                      );
                    }));
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 200,
            width: 170,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColour.grey.withOpacity(0.1)),
            child: Column(
              children: [
                services.sizedBox(h: 8),
                SizedBox(
                  child: services.cachedImage(
                      imageUrl: product!.image, height: 80.0, width: 80.0),
                ),
                services.sizedBox(h: 5),
                Text(
                  product!.title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Text(
                  services.formatPrice(
                      amount: product!.price, context: context),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
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
              weight: 0.5,
            ))
      ],
    );
  }
}
