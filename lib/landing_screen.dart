import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_shop_app/firebase_services.dart';
import 'package:vendor_shop_app/screens/home_screen.dart';
import 'package:vendor_shop_app/screens/login_screen.dart';
import 'package:vendor_shop_app/screens/registration_screen.dart';

import 'models/vendor_model.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: _service.vendor.doc(_service.user!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.data!.exists) {
          return const RegistrationScreen();
        }
        Vendor vendor = Vendor.fromJson(snapshot.data!.data() as Map<String,dynamic>);
        if(vendor.approved == true){
          return const HomeScreen();
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: vendor.logo ?? '',
                      placeholder: (context,url)=>Container(
                        height: 100,
                        width: 100,
                        color: Colors.grey.shade300,
                      ),

                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(vendor.businessName ?? '', style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),),
                const Text(
                    "Your application is sent to Shop App Admin \ Admin will contact you soon",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
                OutlinedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                    ),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen(),
                        ),
                      );
                    });
                  },
                  child: Text('Sign out'),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
