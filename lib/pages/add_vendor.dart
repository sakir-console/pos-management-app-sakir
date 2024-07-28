import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:cool_alert/cool_alert.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
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

import 'dash_test.dart';
 

class AddVendor extends StatefulWidget {
  const AddVendor({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddVendor> {
  final List<Map<String, dynamic>> _subCatFirst = [
    {
      'value': 'selectCat',
      'label': ' Select Category First',
      'icon': Icon(Icons.warning_amber_rounded),
      'textStyle': TextStyle(color: Colors.red),
      'enable': false
    },
  ];
  final List<Map<String, dynamic>> _divFirst = [
    {
      'value': 'selectCat',
      'label': ' Select Division First',
      'icon': Icon(Icons.warning_amber_rounded),
      'textStyle': TextStyle(color: Colors.red),
      'enable': false
    },
  ];

  final List<Map<String, dynamic>> _disFirst = [
    {
      'value': 'selectCat',
      'label': ' Select District First',
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
  final vendorName = TextEditingController();
  final categoryId = TextEditingController();
  final subCategoryId = TextEditingController();

  final divId = TextEditingController();
  final disId = TextEditingController();
  final upaId = TextEditingController();
  final uniId = TextEditingController();

  final vendorEmail = TextEditingController();
  final vendorPhone = TextEditingController();
  final vendorAddress = TextEditingController();

  dynamic lgt = '';
  dynamic ltt = '';
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

  List<Map<String, dynamic>> getDivs = [];
  List<Map<String, dynamic>> getDis = [
    {
      'value': 'noSubCat',
      'label': 'Select Division',
      'icon': Icon(Icons.signal_cellular_null),
      'textStyle': TextStyle(color: Colors.red),
      'enable': false
    }
  ];
  List<Map<String, dynamic>> getUpa = [ {
    'value': 'noSubCat',
    'label': 'Select District first',
    'icon': Icon(Icons.signal_cellular_null),
    'textStyle': TextStyle(color: Colors.red),
    'enable': false
  }];
  List<Map<String, dynamic>> getUni = [
    {
      'value': 'noSubCat',
      'label': 'Select Upazila First',
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
        //print(data['data'][i]['id']);
        //print(data['data'][i]['name']);
        //getCats.add(Cat(value:data['data'][i]['id'],label:data['data'][i]['name'] ,icon: Icons.adjust ));
        getCats.add({
          'value': data['data'][i]['id'],
          'label': data['data'][i]['name'],
          'icon': const Icon(Icons.stop),
        });
      }
    }
  }

  Future subCategoryList() async {

    getSubCats.clear();
    print("No SubCategory-------$noSubCat");
    var data = await getApi("vendor-subcategory/${categoryId.text}");
    if (data['result'] == true) {
      for (int i = 0; i < data['data'].length; i++) {
        getSubCats.add({
          'value': data['data'][i]['id'],
          'label': data['data'][i]['name'],
          'icon': Icon(Icons.stop),
        });
      }
      setState(() {
        if (data['data'].isEmpty) {
          noSubCat = true;
         // print("No SubCategory======$noSubCat");
        } else {
          noSubCat = false;
         // print("No SubCategory======$noSubCat");
        }
      });
    }
  }

  Future divList() async {
    getDivs.clear();
    var data = await getApi("divisions");
    if (data['result'] == true) {
      for (int i = 0; i < data['data'].length; i++) {
        getDivs.add({
          'value': data['data'][i]['id'],
          'label': data['data'][i]['name'],
          'icon': const Icon(Icons.stop),
        });
      }
    }
  }

  Future districtList() async {
    getDis.clear();
    var data = await getApi("districts/${divId.text}");
    if (data['result'] == true) {
      for (int i = 0; i < data['data'].length; i++) {
        getDis.add({
          'value': data['data'][i]['id'],
          'label': data['data'][i]['name'],
          'icon': Icon(Icons.stop),
        });
      }

    }
  }

  Future upazilaList() async {
    getUpa.clear();
    var data = await getApi("upazilas/${disId.text}");
    if (data['result'] == true) {
      for (int i = 0; i < data['data'].length; i++) {
        getUpa.add({
          'value': data['data'][i]['id'],
          'label': data['data'][i]['name'],
          'icon': Icon(Icons.stop),
        });
      }

    }
  }


  Future addVendor() async {
    var data = await postApi("vendor/create",
        {"vendor_name": vendorName.text,
               "vendor_email": vendorEmail.text,
               "phone": vendorPhone.text,
               "lgt":lgt.toString(),
               "ltt":ltt.toString(),
               "div_id": divId.text,
               "dis_id": disId.text,
               "upa_id": upaId.text,
               "address": vendorAddress.text,
               "vnd_cat_id": categoryId.text,
               "vnd_subcat_id": subCategoryId.text
        }, header: false);

    if (data['result'] == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashTest(),
          ),
              (route) => false);

      Fluttertoast.showToast(
          msg: "${data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      //Navigator.of(context, rootNavigator: true).pop(context);

      Fluttertoast.showToast(
          msg: data['message'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFB40284A),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryList();
    divList();
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
            fontFamily: 'Raleway',
            //colorScheme: ColorScheme(background: Color(0xffe7e9f0), brightness: null, primary: null, onPrimary: null, secondary: null, onSecondary: null, error: null)

        ),
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
                    controller: vendorName,
                    maxLines: 3,
                    minLines: 2,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.title_rounded),
                      hintText: 'Vendor name',
                      labelText: 'Enter vendor name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12), // Transparent border
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent), // Transparent border
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
                          subCategoryId.clear();
                        });
                        //print("Category ID: $val");
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
                      items: categoryId == null
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
                //height: 180,
                child: CustomContainer(
                    child: Column(
                  children: [
                    SelectFormField(
                      controller: divId,
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      // initialValue: 'cat',
                      icon: Icon(Icons.location_pin),
                      labelText: 'Division',
                      items: getDivs,
                      onChanged: (val) {
                        setState(() {
                          print("See Div: ${divId.text}");
                          disId.clear();
                          upaId.clear();
                          print("checkkkk ${upaId.text}");
                        });
                        districtList();
                      },

                      onSaved: (val) => print("onSaved: $val"),
                    ),

                    SelectFormField(
                      controller: disId,
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      // initialValue: 'sub-cat',

                      icon: Icon(Icons.catching_pokemon_sharp),
                      labelText: 'District',
                      items: divId.text.isEmpty
                          ? _divFirst: getDis,
                      onChanged: (val) {
                        setState(() {
                          print("See Dis: ${disId.text}");
                          upaId.clear();
                        });
                        upazilaList();
                      },
                      onSaved: (val) => print("Dis onSaved: $val"),
                    ),
                    SelectFormField(
                      controller: upaId,
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      // initialValue: 'sub-cat',

                      icon: Icon(Icons.catching_pokemon_sharp),
                      labelText: 'Upazila',
                      items: disId.text.isEmpty
                          ? _disFirst: getUpa,
                      onChanged: (val) {

                      },
                      onSaved: (val) => print("Upa onSaved: $val"),
                    ),

                  ],
                )),
              ),





              Container(

                child: CustomContainer(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: vendorEmail,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 3,
                      minLines: 2,
                      decoration: const InputDecoration( enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12), // Transparent border
                      ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                        icon: Icon(Icons.alternate_email),
                        hintText: 'Email',
                        //prefix: Text('৳ '),
                        labelText: 'Enter email',
                      ),
                    ),
                    TextFormField(
                      controller: vendorPhone,
                      keyboardType: TextInputType.number,
                      maxLines: 3,
                      minLines: 2,
                      decoration: const InputDecoration( enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12), // Transparent border
                      ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                        icon: Icon(Icons.mobile_friendly_rounded),
                        hintText: 'Phone number',
                        labelText: 'Enter Phone number *',
                      ),
                    ),

                  ],
                )),
              ),

              Container(

                child: CustomContainer(
                  child: TextFormField(
                    controller: vendorAddress,
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12), // Transparent border
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent), // Transparent border
                      ),
                      icon: Icon(Icons.location_on_outlined),
                      hintText: 'Enter address',
                      labelText: 'Shop address',
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                height: 400,
                child: OpenStreetMapSearchAndPick(
                  buttonTextStyle:
                  const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
                  buttonColor: Colors.blue,
                  buttonText: 'Set Current Location',
                  onPicked: (pickedData) {
                    print(pickedData.latLong.latitude);
                    print(pickedData.latLong.longitude);
                    print(pickedData.address);
                    print(pickedData.addressName);

                    setState(() {
                      lgt=pickedData.latLong.longitude;
                      ltt=pickedData.latLong.latitude;
                      vendorAddress.text=pickedData.addressName;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    addVendor();
                  },
                  child: Text('Add shop'),
                ),
              ),
              SizedBox(
                height: 30,
              ),

            ],
          ),
        ));
  }
}
