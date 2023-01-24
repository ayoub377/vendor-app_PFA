import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/provider/vendor_provider.dart';

import '../widget/add_product/custom_drawer.dart';



class HomeScreen extends StatelessWidget {
  static String id="home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);
    if(_vendorData.doc == null){
      _vendorData.getVendorData();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Dashboard"),
      ),
      body: Center(
        child:Text("Home screen!"),
      ),
      drawer: CustomDrawer(),
    );
  }
}
