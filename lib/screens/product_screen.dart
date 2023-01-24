import 'package:flutter/material.dart';
import 'package:vendor_shop_app/widget/add_product/custom_drawer.dart';


class ProductScreen extends StatelessWidget {
  static const String id = "product-screen";
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Products"),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text("Product screen"),
      ),
    );
  }
}
