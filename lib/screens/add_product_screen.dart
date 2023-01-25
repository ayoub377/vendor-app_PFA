import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/firebase_services.dart';
import 'package:vendor_shop_app/provider/product_provider.dart';
import 'package:vendor_shop_app/provider/vendor_provider.dart';
import 'package:vendor_shop_app/widget/add_product/custom_drawer.dart';
import 'package:vendor_shop_app/widget/add_product/images_tab.dart';
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
    final _vendor = Provider.of<VendorProvider>(context);
    final _formkey = GlobalKey<FormState>();
    FirebaseService _services = FirebaseService();
    return Form(
      key: _formkey,
      child: DefaultTabController(
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
          drawer: const CustomDrawer(),
          body: const TabBarView(
            children: [
              GeneralTab(),
              InventoryTab(),
              ShippingTab(),
              AttributeTab(),
              Center(child: Text("Link Pro Tab"),),
              ImagesTab()
            ],
          ),
          persistentFooterButtons: [
            ElevatedButton(
              child: const Text('save Product'),
                onPressed: (){
                if(_provider.imageFiles!.isEmpty){
                  _services.scaffold(context, 'image not selected');
                  return ;
                }
                  if(_formkey.currentState!.validate()){
                    EasyLoading.show(status: 'Please wai...');
                    _provider.getFormData(
                      seller: {
                        'name': _vendor.vendor!.businessName,
                        'uid': _services.user!.uid,
                      }
                    );
                  _services.uploadFiles(images: _provider.imageFiles,
                  ref: 'products/${_vendor.vendor!.businessName}/${_provider.productData!['productName']}',
                    provider: _provider
                  ).then((value) {
                    if(value.isNotEmpty){
                      _services.saveToDb(
                        data: _provider.productData,
                        context: context
                      ).then((value) {
                        EasyLoading.dismiss();



                        // had setState mabghatch tkhdem
                        setState((){
                          _provider.clearProductData();
                        });





                      });
                    }
                  });
                  }
                },)
          ],
        ),
      ),
    );
  }
}
