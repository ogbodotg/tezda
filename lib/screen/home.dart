import 'package:flutter/material.dart';
import 'package:tezda/api/api_call.dart';
import 'package:tezda/api/endpoint.dart';
import 'package:tezda/model/products.dart';
import 'package:tezda/screen/widgets/product_card.dart';
import 'package:tezda/services/services.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CallApi _callApi = CallApi();

  Services services = Services();
  List products = [];

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  fetchProducts() async {
    products = await _callApi.callApi(
      context: context,
      endpoint: EndPoint.products,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: services.mainAppBar(context: context),
      body: products.isNotEmpty
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
          : Center(
              child: services.showLoader(40),
            ),
    );
  }
}
