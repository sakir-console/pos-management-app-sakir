import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:cool_alert/cool_alert.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:pos_by_sakir/extends/multipart_request.dart';
import 'package:pos_by_sakir/utils/constants.dart';
import 'package:pos_by_sakir/utils/helpers/api.dart';
import 'package:pos_by_sakir/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final List<Map<String, dynamic>> _subCatFirst = [
    {
      'value': 'selectCat',
      'label': ' Select Category First',
      'icon': Icon(Icons.warning_amber_rounded),
      'textStyle': TextStyle(color: Colors.red),
      'enable': false
    },
  ];
  final List<Map<String, dynamic>> _noSubCats = [
    {
      'value': 'noSubCat',
      'label': ' No Sub Category added.',
      'icon': Icon(Icons.signal_cellular_null),
      'textStyle': TextStyle(color: Colors.red),
      'enable': false
    },
  ];

  late ProgressDialog pr;
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productSPrice = TextEditingController();
  final productStock = TextEditingController();
  final productUnit = TextEditingController();
  final productDesc = TextEditingController();
  final categoryId = TextEditingController();
  final subCategoryId = TextEditingController();
  var catSelected;
  bool isPicked = false;
  late double progress;
  List<Map<String, dynamic>> getCats = [];
  List<Map<String, dynamic>> getSubCats = [
    {
      'value': 'noSubCat',
      'label': 'No Sub Category added.',
      'icon': Icon(Icons.signal_cellular_null),
      'textStyle': TextStyle(color: Colors.red),
      'enable': false
    }
  ];

  bool noSubCat = false;
  Future categoryList() async {
    getCats.clear();
    //print(getSubCats.length);
    var data = await getApi("vendor-category");
    if (data['result'] == true) {
      for (int i = 0; i < data['data'].length; i++) {
        print(data['data'][i]['id']);
        print(data['data'][i]['name']);
        //getCats.add(Cat(value:data['data'][i]['id'],label:data['data'][i]['name'] ,icon: Icons.adjust ));
        getCats.add({
          'value': data['data'][i]['id'],
          'label': data['data'][i]['name'],
          'icon': Icon(Icons.stop),
        });
      }
    }
  }

  Future subCategoryList() async {
    getSubCats.clear();
    print("No SubCategory-------$noSubCat");
    var data = await getApi("nnnn");
    if (data['result'] == true) {
      for (int i = 0; i < data['data'].length; i++) {
        print(data['data'][i]['id']);
        print(data['data'][i]['name']);
        //getCats.add(Cat(value:data['data'][i]['id'],label:data['data'][i]['name'] ,icon: Icons.adjust ));
        getSubCats.add({
          'value': data['data'][i]['id'],
          'label': data['data'][i]['name'],
          'icon': Icon(Icons.stop),
        });
      }
      setState(() {
        if (data['data'].isEmpty) {
          noSubCat = true;
          print("No SubCategory======$noSubCat");
        } else {
          noSubCat = false;
          print("No SubCategory======$noSubCat");
        }
      });
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.categoryList();

  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      textDirection: TextDirection.rtl,
      isDismissible: false,
      /*    customBody: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
       backgroundColor: Colors.white,
     ),*/
    );

    pr.style(
//      message: 'Downloading file...',
      message: 'Please wait.. ',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInExpo,
      progress: 0.0,
      textAlign: TextAlign.center,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
                .copyWith(
                secondary: Colors.blueGrey,
                surface: Colors.blueAccent),
             fontFamily: 'Raleway'),
        home: Scaffold(
          backgroundColor: Color(0xffdee4eb),
          appBar: AppBar(
            title: Text("Add Vendor",
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                )),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Container(
                  height: 21,
                  width: 21,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.view_list,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: ListView(
            shrinkWrap: true,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 130,
                child: CustomContainer(
                  child: TextFormField(
                    controller: productName,
                    maxLines: 3,
                    minLines: 2,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.title_rounded),
                      hintText: 'Vendor name',
                      labelText: 'Enter vendor name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12), // Color when unfocused
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue), // Color when focused
                      ),
                    ),
                  ),

                ),
              ),
              Container(
                height: 180,
                child: CustomContainer(
                    child: Column(
                      children: [
                        SelectFormField(
                          controller: categoryId,

                          type: SelectFormFieldType.dropdown, // or can be dialog
                          // initialValue: 'cat',
                          icon: Icon(Icons.adjust_outlined),
                          labelText: 'Category *',
                          items: getCats,
                          onChanged: (val) {
                            print("onChanged: $val");
                            setState(() {
                              catSelected = val;
                            });
                            print("Category ID: $val");
                            subCategoryList();
                          },

                          onSaved: (val) => print("onSaved: $val"),
                        ),
                        SelectFormField(
                          controller: subCategoryId,
                          type: SelectFormFieldType.dropdown, // or can be dialog
                          // initialValue: 'sub-cat',

                          icon: Icon(Icons.catching_pokemon_sharp),
                          labelText: 'Sub Category *',
                          items: catSelected == null
                              ? _subCatFirst
                              : noSubCat
                              ? _noSubCats
                              : getSubCats,
                          onChanged: (val) {
                            print("Sub-Category ID: $val");
                          },
                          onSaved: (val) => print("onSaved: $val"),
                        ),
                      ],
                    )),
              ),

              Container(
                height: 380,
                child: CustomContainer(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: productPrice,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 3,
                          minLines: 2,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.alternate_email),
                            hintText: 'Email',
                            //prefix: Text('৳ '),
                            labelText: 'Enter email',
                          ),
                        ),
                        TextFormField(
                          controller: productSPrice,
                          keyboardType: TextInputType.number,
                          maxLines: 3,
                          minLines: 2,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.local_offer_outlined),
                            hintText: 'Phone number',
                            labelText: 'Enter Phone number *',
                          ),
                        ),
                        TextFormField(
                          controller: productStock,
                          keyboardType: TextInputType.number,
                          maxLines: 3,
                          minLines: 2,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.stop_circle_outlined),
                            labelText: 'Product Stock *',
                            hintText: 'Enter Product Quantity',
                          ),
                        ),
                        TextFormField(
                          controller: productUnit,
                          // keyboardType: TextInputType.number,
                          maxLines: 3,
                          minLines: 2,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.animation),
                            labelText: 'Product Unit *',
                            hintText: 'KG/litre etc..',
                          ),
                        ),
                      ],
                    )),
              ),
              Container(
                height: 180,
                child: CustomContainer(
                  child: TextFormField(
                    controller: productDesc,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.description_outlined),
                      hintText: 'Enter Product description',
                      labelText: 'Product Description *',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    await pr.show();
                    categoryList();
                  },
                  child: Text('Add product'),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ));
  }
}
