import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService{

  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference vendor = FirebaseFirestore.instance.collection('vendor');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference mainCategories = FirebaseFirestore.instance.collection('mainCategories');
  CollectionReference subCategories = FirebaseFirestore.instance.collection('subCategories');

  final storage = FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file,String? reference) async{
    final storageRef = storage.ref('$reference/${user!.uid}');
    File _file = File(file!.path);
    await storageRef.putFile(_file);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;

  }


  Future<void> addVendor({Map<String, dynamic>? data}) {
    // Call the user's CollectionReference to add a new user
    return vendor.doc(user!.uid)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  String formattedDate(date){
    var outPutFormate = DateFormat('dd/MM/yyyy hh:mm aa');
    var outPutDate = outPutFormate.format(date);
    return outPutDate;
  }

  Widget formField({String? label, TextInputType? inputType, Function(String)? onChanged,
    int? minLine, int? maxLine}){
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
          label: Text(label!)
      ),
      validator: (value){
        if(value!.isEmpty){
          return label;
        }
      },
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }




}