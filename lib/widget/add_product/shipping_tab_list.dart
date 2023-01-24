import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/firebase_services.dart';
import 'package:vendor_shop_app/provider/product_provider.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> {
  bool? _chargeShipping=false;
  FirebaseService _service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder:(context,provider,child){
      return ListView(
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.all(20.0),
            title: Text("Charge Shipping?",style: TextStyle(
              color: Colors.grey
            ),),
              value: _chargeShipping,
              onChanged: (value){
                setState(() {
                  _chargeShipping = value;
                  provider.getFormData(
                    chargeShipping: value
                  );
                });
              }
          ),
          if(_chargeShipping == true)
          _service.formField(
            label: 'Shipping charge',
            inputType: TextInputType.number,
            onChanged: (value){
              provider.getFormData(
                shippingCharge: int.parse(value)
              );
            }
          )

        ],
      );
    }
    );
  }
}
