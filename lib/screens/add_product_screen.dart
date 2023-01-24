import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/provider/product_provider.dart';
import 'package:vendor_shop_app/widget/add_product/custom_drawer.dart';
import 'package:vendor_shop_app/widget/add_product/inventory_tab.dart';
import 'package:vendor_shop_app/widget/add_product/shipping_tab_list.dart';

import '../widget/add_product/attribute_tab.dart';
import '../widget/add_product/general_tab.dart';

class AddProductScreen extends StatelessWidget {
  static const String id="add-product";
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Add new products"),
          bottom: TabBar(
            isScrollable: true,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 4,
                color: Colors.deepOrangeAccent
              )
            ),
            tabs: [
              Tab(
                child: Text("General"),
              ),
              Tab(
                child: Text("Inventory"),
              ),
              Tab(
                child: Text("Shipping"),
              ),
              Tab(
                child: Text("Attributes"),
              ),
              Tab(
                child: Text("Linked Products"),
              ),
              Tab(
                child: Text("Images"),
              )
            ],
          ),
        ),
        drawer: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomDrawer(),
        ),
        body: const TabBarView(
          children: [
            GeneralTab(),
            InventoryTab(),
            ShippingTab(),
            AttributeTab(),
            Center(child: Text("Link Pro Tab"),),
            Center(child: Text("Images Tab"),)
          ],
        ),
        persistentFooterButtons: [
          ElevatedButton(
              onPressed: (){
                print(_provider.productData);
              }, child:Text("Save Product"))
        ],
      ),
    );
  }
}
