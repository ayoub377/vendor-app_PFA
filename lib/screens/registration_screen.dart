import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:vendor_shop_app/firebase_services.dart';
import 'package:vendor_shop_app/landing_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseService _service = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _gstNumber = TextEditingController();
  final _email = TextEditingController();
  final _pinCode = TextEditingController();
  final _landmark = TextEditingController();


  String? _bName;
  String? _taxStatus;
  String? countryValue;
  String? stateValue;
  String? cityValue;
  final ImagePicker _picker = ImagePicker();
  XFile? image ;
  XFile? _logo;
  String? _shopImageUrl;
  String? _logoImageUrl;

  Widget _formField({TextEditingController? controller, String? label, TextInputType? type, String? Function(String?)? validator  }){
    return TextFormField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
       labelText: label
     ),
      validator: validator,
        onChanged:(value){
        if(controller == _businessName){
          setState(() {
            _bName = value;
          });
        }
        },
    );
  }
  _scaffold(message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: (){
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),));
  }
  _saveToDb(){
    if(image==null){
      _scaffold('Shop Image not selected');
      return;
    }
    if(_logo == null){
      _scaffold('Logo not selected');
      return;
    }
    if(_formKey.currentState!.validate()){
      if(countryValue  == null ||stateValue  == null || cityValue == null){
        _scaffold('Select address field completly');
        return;
      }
      EasyLoading.show(status: 'Please wait...');
      _service.uploadImage(image, 'vendors/${_service.user!.uid}/shopImage.jpg').then((url) => {
        if(url!=''){
          setState((){
            _shopImageUrl = url;
          })
        }
      }).then((value) => {
        _service.uploadImage(image, 'vendors/${_service.user!.uid}/logo.jpg').then((url) => {
          if(url != ''){
            setState((){
              _logoImageUrl = url;
            })
          }
        }).then((value) => {
          _service.addVendor(
              data: {
                'shopImage':_shopImageUrl,
                'logo':_logoImageUrl,
                'businessName':_businessName.text,
                'mobile':_contactNumber.text,
                'email':_email.text,
                'taxRegistered':_taxStatus,
                'tinNumber':_gstNumber.text.isEmpty?null:_gstNumber.text,
                'pinCode':_pinCode.text,
                'landmark':_landmark.text,
                'country':countryValue,
                'state':stateValue,
                'city':cityValue,
                'approved':false,
                'uid':_service.user!.uid,
                'time':DateTime.now()
              }
          ).then((value) => {
            EasyLoading.dismiss(),
            Navigator.of(context).pushReplacement(MaterialPageRoute (
              builder: (BuildContext context) => const LandingScreen(),
            ),)
          })

        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue,
                      height: 240,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero
                        ),
                        child: image == null ? Center(
                          child: Text('Tap to add shop image',style: TextStyle(
                              color: Colors.grey.shade800
                          ),),
                        ):InkWell(
                          child: Container(
                            height: 240,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(image!.path)),
                                fit: BoxFit.cover,
                                opacity: 100,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          XFile? fileImage = await _picker.pickImage(source: ImageSource.gallery);
                         setState(() {
                           image = fileImage;
                         });
                        },
                      )
                    ),
                    SizedBox(
                      height: 80,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        actions: [
                          IconButton(onPressed: (){
                            FirebaseAuth.instance.signOut();
                          },
                              icon: const Icon(Icons.exit_to_app))
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children:[
                            InkWell(
                              onTap: () async {
                      XFile? fileImage = await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                      _logo = fileImage;
                      });
                      },
                              child: Card(
                                elevation:4,
                                child: _logo == null ? SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(child: Text("+")),
                                ):ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.file(File(_logo!.path),fit: BoxFit.cover,)
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(_bName==null? '':_bName!, style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.white,
                              fontSize: 20
                            ),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                child: Column(
                  children: [
                       _formField(
                         controller: _businessName,
                         label: 'Business name',
                         type: TextInputType.text,
                         validator: (value){
                           if(value!.isEmpty){
                             return 'Enter Business name';
                           }
                           return null;
                         }
                       ),
                    _formField(
                        controller: _contactNumber,
                        label: 'Contact number',
                        type: TextInputType.phone,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Contact number';
                          }
                          return null;
                        }
                    ),
                    _formField(
                        controller: _email,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Email address';
                          }
                          else if(!EmailValidator.validate(value)){
                            return 'Enter Valid Email';
                          }
                          return null;
                        }
                    ),
                    Row(
                      children: [
                        const Text("Tax Registred:"),
                        SizedBox(width: 20,),
                        Expanded(
                          child: DropdownButtonFormField(
                            validator: (value){
                              if(value == null){
                                return 'Select Tax Status';
                              }
                            },
                              value: _taxStatus,
                              hint: const Text('Select'),
                              items: <String>['Yes','No'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value){
                                setState(() {
                                  _taxStatus = value;
                                });
                          }),
                        ),
                      ],
                    ),
                    if(_taxStatus == 'Yes')
                      _formField(
                          controller: _gstNumber,
                          label: 'GST Number',
                          type: TextInputType.text,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter GST number';
                            }
                            return null;
                          }
                      ),
                    _formField(
                        controller: _pinCode,
                        label: 'Pin code',
                        type: TextInputType.number,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Pin code';
                          }
                          return null;
                        }
                    ),
                    _formField(
                        controller: _landmark,
                        label: 'Landmark',
                        type: TextInputType.number,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter a landmark';
                          }
                          return null;
                        }
                    ),
                    SizedBox(height: 20,),
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.ENABLE,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade300,
                          border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "*Country",
                      stateDropdownLabel: "*State",
                      cityDropdownLabel: "*City",

                      ///Default Country
                      defaultCountry: DefaultCountry.Morocco,

                      ///Disable country dropdown (Note: use it with default country)
                      //disableCountry: true,

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },
                    ),


                  ],
                ),
              )
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: _saveToDb,
                        child: Text("Register")
                    ),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}
