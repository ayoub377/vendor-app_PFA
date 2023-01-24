
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/provider/vendor_provider.dart';
import 'package:vendor_shop_app/screens/home_screen.dart';
import 'package:vendor_shop_app/screens/login_screen.dart';

import '../../screens/add_product_screen.dart';
import '../../screens/product_screen.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _vendorData = Provider.of<VendorProvider>(context);
    Widget _menu({String? menuTitle, IconData? icon, String? route}){
      return ListTile(
        leading:Icon(icon),
        title: Text(menuTitle!),
        onTap: (){
          Navigator.pushReplacementNamed(context,route!);
        },
      );
    }


    return Drawer(
      child: Column(
        children: [
          Container(
              height: 120,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  DrawerHeader(
                      child: _vendorData.doc == null? Text("Fetching...",style: TextStyle(
                        color: Colors.white
                      ),):Row(
                       children: [
                         CachedNetworkImage(imageUrl: _vendorData.doc!['logo']),
                         SizedBox(width: 10,),
                         Text(_vendorData.doc!['businessName'],style: TextStyle(
                           color: Colors.white
                         ),)
                       ],
                      )
                  ),
                ],
              )),
          Expanded(
            child: ListView(
              padding:EdgeInsets.zero,
              children: [
                _menu(
                  menuTitle: "Home",
                  icon: Icons.home_outlined,
                  route: HomeScreen.id
                ),
               ExpansionTile(
                 leading: Icon(Icons.weekend_outlined),
                 title: Text("Products"),
                 children: [
                   _menu(
                     menuTitle: 'All Products',
                     route: ProductScreen.id
                   ),
                   _menu(
                     menuTitle: "Add Product",
                     route: AddProductScreen.id

                   )
                 ],
               )

              ],
            ),
          ),
          ListTile(
            title: Text("Sign Out"),
            trailing: Icon(Icons.exit_to_app),
            onTap: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          )
        ],
      ),
    );
  }
}
