import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor_shop_app/firebase_services.dart';



class VendorProvider with ChangeNotifier{

   FirebaseService _services = FirebaseService();
   DocumentSnapshot? doc;

   getVendorData(){
     _services.vendor.doc(_services.user!.uid).get().then((document){
      doc = document;
      notifyListeners();
     });
   }

}