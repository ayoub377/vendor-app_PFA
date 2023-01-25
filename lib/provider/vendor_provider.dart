import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor_shop_app/firebase_services.dart';
import 'package:vendor_shop_app/models/vendor_model.dart';



class VendorProvider with ChangeNotifier{

   FirebaseService _services = FirebaseService();
   DocumentSnapshot? doc;
   Vendor? vendor;

   getVendorData(){
     _services.vendor.doc(_services.user!.uid).get().then((document){
      doc = document;
      vendor = Vendor.fromJson(document.data() as Map<String,dynamic>);
      notifyListeners();
     });
   }

}