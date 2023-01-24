import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/core/configs.dart';
import 'package:vendor_shop_app/provider/product_provider.dart';
import 'package:vendor_shop_app/provider/vendor_provider.dart';
import 'package:vendor_shop_app/screens/add_product_screen.dart';
import 'package:vendor_shop_app/screens/home_screen.dart';
import 'package:vendor_shop_app/screens/login_screen.dart';
import 'package:vendor_shop_app/screens/product_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    GoogleProvider(clientId: Configs.goolgle_client_id),
    PhoneAuthProvider(),
  ]);
  runApp(
      MultiProvider(
        providers: [
          Provider<VendorProvider>(create: (_) => VendorProvider()),
          Provider<ProductProvider>(create: (_) => ProductProvider()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SplashScreen(),
      routes: {
        HomeScreen.id:(context)=>HomeScreen(),
        ProductScreen.id:(context)=>ProductScreen(),
        AddProductScreen.id:(context)=> AddProductScreen(),
        LoginScreen.id:(context)=> LoginScreen()
      },
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget{
   const SplashScreen({Key? key}): super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),(){
      Navigator.pushReplacement (
        context,
        MaterialPageRoute (
          builder: (BuildContext context) => const LoginScreen()
        ),
      );
        }
    );
    super.initState();
  }
  
   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("ShoppApp",textAlign: TextAlign.center,style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),),
            Text("Vendor",style: TextStyle(
              fontSize: 20
            ),)
          ],
        ),
      ),
    );
  }
}
//
// class SplashScreen extends StatelessWidget{
//    SplashScreen({Key? key}) : super(key: key)
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("ShoppApp\nVendor"),
//       ),
//     );
//   }
//
//
// }