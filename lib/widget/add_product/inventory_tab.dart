import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/firebase_services.dart';
import 'package:vendor_shop_app/provider/product_provider.dart';


class InventoryTab extends StatefulWidget {
  const InventoryTab({Key? key}) : super(key: key);

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive=>true;
  FirebaseService _services = FirebaseService();
  bool? _manageInventory = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(
        builder: (context, provider,_) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [

                _services.formField(
                  label: 'SKU',
                  inputType: TextInputType.text,
                  onChanged: (value){
                   provider.getFormData(
                     sku: value
                   );
                  }
                ),

                CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Manage Inventory ? ", style: TextStyle(
                      color: Colors.grey
                    ),),
                    value: _manageInventory,
                    onChanged: (value){
                      setState(()
                      {
                        _manageInventory=value;

                      });
                }),
                if(_manageInventory == true)
                Column(
                  children: [
                    _services.formField(
                      label: 'Stock on hand',
                      inputType: TextInputType.number,
                      onChanged: (value){
                        provider.getFormData(
                          soh: int.parse(value)
                        );
                      }
                    ),
                    _services.formField(
                        label: 'Re-order level',
                        inputType: TextInputType.number,
                        onChanged: (value){
                          provider.getFormData(
                              reOrderLevel: int.parse(value)
                          );
                        }
                    )
                  ],
                ),
              ],
            ),
          );
    },);
  }
}
