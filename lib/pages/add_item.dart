import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/pages/add_item_category.dart';
import 'package:pos_by_sakir/utils/helpers/api.dart';

class ItemAddScreen extends StatefulWidget {
  const ItemAddScreen({super.key});

  @override
  _ItemAddScreenState createState() => _ItemAddScreenState();
}

class _ItemAddScreenState extends State<ItemAddScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> selectedImages = [];
  final List<TextEditingController> _quantity = [];
  final List<TextEditingController> _price = [];
  final _formkey = GlobalKey<FormState>();

  List<MultiSelectItem<Category>> catList = [];

  _addField() {
    setState(() {
      _quantity.add(TextEditingController());
      _price.add(TextEditingController());
    });
  }

  _removeField(int i) {
    if (_quantity.length > 1 && _price.length > 1) {
      setState(() {
        _quantity.removeAt(i);
        _price.removeAt(i);

        qtys.clear();
        prices.clear();
      });
    }
  }


  Future<void> addImages() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage(
      maxWidth: 800, // can be customized
      maxHeight: 600, // can be customized
    );

    if (images != null) {
      setState(() {
        selectedImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  List<String> catIds = [];
  List<String> qtys = [];
  List<String> prices = [];

  Future<void> createProduct() async {
    try {
      qtys.clear();
      prices.clear();
      for (int i = 0; i < _quantity.length; i++) {
        if (_quantity[i].text != "" && _price[i].text != "") {
          qtys.add(_quantity[i].text);
          prices.add(_price[i].text);
        }
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      Map<String, dynamic> body = {
        "item_name": nameController.text,
        'vendor_id': preferences.getInt('vnd').toString(),
        'about': descriptionController.text,
        'ingrs': ingredientController.text,
      };

      body['cat_id'] = catIds;
      body['qtys'] = qtys;
      body['price'] = prices;

      await multipartApi('item/add', body, selectedImages, context);
    } catch (e) {
      throw Exception(e);

      debugPrint("$e");
    }
  }

  Future viewCategories() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    debugPrint("--- Categories called");
    var data = await postApi(
        "item-categories", {'vendor_id': preferences.getInt('vnd').toString()});
    if (data['data'] != null) {
      if (data['result'] == true) {
        List<Category> cats =
        []; // Create a temporary list to hold the parsed data
        for (int i = 0; i < data['data'].length; i++) {
          // Parse the data and create Animal objects
          Category cat = Category(
            id: data['data'][i]['id'],
            name: data['data'][i]['name'],
          );
          cats.add(cat); // Add the created Animal to the list
        }
        setState(() {
          catList = cats
              .map((cat) => MultiSelectItem<Category>(cat, cat.name))
              .toList();
        });
      } else {
        Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ingredientController.dispose();
    descriptionController.dispose();
    for (var controller in _quantity) {
      controller.dispose();
    }
    for (var controller in _price) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    _quantity.add(TextEditingController());
    _price.add(TextEditingController());
    viewCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(secondary: Colors.blueGrey, surface: Colors.blueAccent),
          fontFamily: 'Raleway'),
      home: Scaffold(
        appBar: AppBar(
          title: Text("New Item",
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
          actions: const <Widget>[

          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: ingredientController,
                decoration: InputDecoration(labelText: 'Ingredients'),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(
                height: 100,
              ),
              MultiSelectDialogField(
                //dialogHeight: 380,
                searchable: true,
                items: catList,
                title: Text("Categories"),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.pets,
                  color: Colors.blue,
                ),
                buttonText: Text(
                  "Select Category",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  List<String> selectedCategoryNames = results
                      .map((category) => category.id.toString())
                      .toList();
                  catIds = selectedCategoryNames;
                  debugPrint("$selectedCategoryNames"); // Print selected values
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Icon(Icons.add_circle),
                    onTap: () {
                      _addField();
                    },
                  )
                ],
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      for (int i = 0; i < _quantity.length; i++)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: Icon(Icons.remove_circle),
                                  onTap: () {
                                    _removeField(i);
                                  },
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: TextFormField(
                                        decoration: InputDecoration(labelText: 'Size/Quantity'),
                                        controller: _quantity[i],
                                        validator: (value) {
                                          if (value == "") {
                                            print("Please Enter Quantity");
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: TextFormField(
                                        keyboardType:TextInputType.number ,
                                        controller: _price[i],
                                        decoration: InputDecoration(labelText: 'Price /-'),
                                        validator: (value) {
                                          if (value == "") {
                                            return "Please Enter price";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: TextFormField(
                                        keyboardType:TextInputType.number ,
                                        controller: _price[i],
                                        decoration: InputDecoration(labelText: 'Discount'),
                                        validator: (value) {
                                          if (value == "") {
                                            return "Please Enter price";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    )),
                              ],
                            )
                          ],
                        )
                    ],
                  )),
              ElevatedButton(
                onPressed: addImages,
                child: Text('Add Image'),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedImages
                    .map((image) => Image.file(image,
                        width: 100, height: 100, fit: BoxFit.cover))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: createProduct,
                child: Text('Create Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });
}
