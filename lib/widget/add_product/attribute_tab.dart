import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_shop_app/provider/product_provider.dart';

class AttributeTab extends StatefulWidget {
  const AttributeTab({Key? key}) : super(key: key);

  @override
  State<AttributeTab> createState() => _AttributeTabState();
}

class _AttributeTabState extends State<AttributeTab> with AutomaticKeepAliveClientMixin {
    @override
    bool get wantKeepAlive=>true;
    Widget _formField({String? label, TextInputType? inputType, Function(String)? onChanged,
    int? minLine, int? maxLine}){
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
          label: Text(label!)
      ),

      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }
    final List<String> _sizeList=[];
    final _textSize = TextEditingController();
    bool? _saved=false;
    bool _entered = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context,provider,_){
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _formField(
                label: 'Brand',
                inputType: TextInputType.text,
                onChanged: (value){
                  provider.getFormData(
                    brand: value,
                  );
                }
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textSize,
                    decoration: InputDecoration(
                      label: Text("Size"),
                    ),
                    onChanged: (value){
                      if(value.isNotEmpty){
                        setState(() {
                          _entered = true;
                        });
                      }
                    },
                  )
                ),
                if(_entered)
                ElevatedButton(onPressed: (){
                     setState(() {
                       _sizeList.add(_textSize.text);
                       _textSize.clear();
                       _entered = false;
                       _saved=false;
                     });
                }, child: Text("Add"))
              ],
            ),
            if(_sizeList.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                  itemCount: _sizeList.length,
                  itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onLongPress: (){
                      setState(() {
                        _sizeList.removeAt(index);
                        provider.getFormData(
                          sizeList: _sizeList
                        );
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.orange.shade500,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(_sizeList[index],style: TextStyle(
                          fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                );
              }),
            ),
            if(_sizeList.isNotEmpty)
            Column(
              children: [
                Text("*Long press to delete",style:TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                )),
                ElevatedButton(
                  child:Text(_saved == true? "Saved":"Press to save"),
                    onPressed: (){
                  setState(() {
                    provider.getFormData(
                        sizeList: _sizeList
                    );
                  });
                  _saved=true;
                }),
              ],
            ),
            _formField(
              label: "Add other details",
              maxLine: 2,
              onChanged: (value){
                provider.getFormData(
                  otherDetails: value
                );
              }
            )

          ],
        ),
      );
    });
  }
}