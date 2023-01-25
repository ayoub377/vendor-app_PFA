import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/firebase_services.dart';
import 'package:vendor_shop_app/provider/product_provider.dart';



class GeneralTab extends StatefulWidget {
  const GeneralTab({Key? key}) : super(key: key);

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive=>true;
  final FirebaseService _service = FirebaseService();
  List<String> _categories=[];
  String? _selectedCategory;
  String? _taxStatus;
  String? _taxAmount;
  DateTime? scheduleDate;
  bool? _salesPrice=false;


  Widget _categoryDropDown(ProductProvider provider){
    return DropdownButtonFormField<String>(
        value: _selectedCategory,
        icon: const Icon(Icons.arrow_drop_down),
        hint: const Text("Select Category",style: TextStyle(
          fontSize: 18
        ),),
        elevation: 16,
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            _selectedCategory = value!;
            provider.getFormData(
              category: _selectedCategory
            );
          });
        },
        items: _categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      validator: (value){
          if(value!.isEmpty){
            return 'Select Category';
          }
      },
    );
  }

  Widget _TaxStatusDropDown(ProductProvider provider){
    return DropdownButtonFormField<String>(
      value: _taxStatus,
      icon: const Icon(Icons.arrow_drop_down),
      hint: const Text("Select Tax Status",style: TextStyle(
          fontSize: 18
      ),),
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          _taxStatus = value!;
          provider.getFormData(
              taxStatus: value
          );
        });
      },
      items: ['Taxable','Non Taxable'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value){
        if(value!.isEmpty){
        return 'Select Tax Status';
        }
      },
    );
  }

  Widget _TaxAmountDropDown(ProductProvider provider){
    return DropdownButtonFormField<String>(
      value: _taxAmount,
      icon: const Icon(Icons.arrow_drop_down),
      hint: const Text("Tax Amount",style: TextStyle(
          fontSize: 16
      ),),
      elevation: 16,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          _taxAmount = value;
          provider.getFormData(
              taxPercentage: _taxAmount=='GST-10%'? 10 : 20
          );
        });
      },
      items: ['GST-10%','GST-12%'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value){
        if(value!.isEmpty) {
          return 'Select Tax amounts';
        }
      },
    );
  }

  getCategories(){
    _service.categories.get().then((value){
     value.docs.forEach((element) {
       setState(() {
         _categories.add(element['CatName']);
       });
     });
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context,provider,child){
       return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
             _service.formField(
                  label: 'Enter product name',
                  inputType: TextInputType.name,
                  onChanged: (value){
                    // save in provider
                    provider.getFormData(
                      productName:  value
                    );
                  }
              ),
              _service.formField(
                label:'Enter description',
                inputType: TextInputType.multiline,
                minLine: 2,
                maxLine: 10,
                onChanged: (value){
                provider.getFormData(
                  description: value
                );
                },
              ),
              SizedBox(height: 20,),
              _categoryDropDown(provider),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(provider.productData!['mainCategory'] ??'Select main category',
                    style: TextStyle (
                      fontSize: 16,
                      color: Colors.grey.shade700
                    ),),
                    if(_selectedCategory != null)
                    InkWell(
                        child: const Icon(Icons.arrow_drop_down),
                      onTap: (){
                        showDialog(context: context, builder: (context){
                            return MainCategoryList(
                              selectedCategory: _selectedCategory,
                              provider: provider,
                            );
                        }).whenComplete((){
                          setState(() {

                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black,),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(provider.productData!['subCategory'] ??'Select sub category',
                      style: TextStyle (
                          fontSize: 16,
                          color: Colors.grey.shade700
                      ),),
                    if(provider.productData!['mainCategory'] != null)
                      InkWell(
                        child: const Icon(Icons.arrow_drop_down),
                        onTap: (){
                          showDialog(context: context, builder: (context){
                            return SubCategoryList(
                              selectedMainCategory: provider.productData!['mainCategory'],
                              provider: provider,
                            );
                          }).whenComplete((){
                            setState(() {
                            });
                          });
                        },
                      ),
                  ],
                ),
              ),
              Divider(color: Colors.black,),
              SizedBox(height: 20,),
              _service.formField(
                  label: 'Regular price(\$)',
                  inputType: TextInputType.number,
                  onChanged: (value){
                    // save in provider
                    provider.getFormData(
                        regularPrice: int.parse(value),
                    );
                  }
              ),
              _service.formField(
                  label: 'Sales price(\$)',
                  inputType: TextInputType.number,
                  onChanged: (value){
                    // save in provider
                    if(int.parse(value)>provider.productData!['regularPrice']){
                      _service.scaffold(context, 'Sales price should be less than regular price');
                      return ;
                    }
                    setState(() {
                      provider.getFormData(
                        salesPrice:  int.parse(value),
                      );
                      _salesPrice=true;
                    });
                  }
              ),
              if(_salesPrice == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(5000),).then((value){
                        setState(() {
                          provider.getFormData(
                              scheduleDate: value
                          );
                        });
                      });
                    },
                    child: Text("Schedule",style: TextStyle(
                      color:Colors.blue
                    ),),


                  ),
                  if(provider.productData!['scheduleDate']!=null)
                    Text(_service.formattedDate(provider.productData!['scheduleDate']))
                ],
              ),
              SizedBox(height: 30,),
              _TaxStatusDropDown(provider),
              if(_taxStatus == 'Taxable')
              _TaxAmountDropDown(provider),
            ],

          ),
        );
      },
    );
  }
}


class MainCategoryList extends StatelessWidget {
  final String? selectedCategory;
  final ProductProvider? provider;
  const MainCategoryList({Key? key, this.selectedCategory, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return Dialog(
      child:   FutureBuilder<QuerySnapshot>(
        future: _service.mainCategories.where('category',isEqualTo:selectedCategory).get(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data!.size == 0){
            return Center(
              child: Text("No main Categories"),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index){
                return ListTile(
                  onTap: (){
                     provider!.getFormData(
                       mainCategory: snapshot.data!.docs[index]['mainCategory']
                     );
                     Navigator.pop(context);
                  },
                  title: Text(snapshot.data!.docs[index]['mainCategory']),
                );
          });
        },
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  final String? selectedMainCategory;
  final ProductProvider? provider;
  const SubCategoryList({Key? key, this.selectedMainCategory, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return Dialog(
      child:   FutureBuilder<QuerySnapshot>(
        future: _service.subCategories.where('mainCategory',isEqualTo:selectedMainCategory).get(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data!.size == 0){
            return Center(
              child: Text("No main Categories"),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index){
                return ListTile(
                  onTap: (){
                    provider!.getFormData(
                        subCategory: snapshot.data!.docs[index]['subCatName']
                    );
                    Navigator.pop(context);
                  },
                  title: Text(snapshot.data!.docs[index]['subCatName']),
                );
              });
        },
      ),
    );
  }
}