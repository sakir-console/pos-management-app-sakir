import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/repositories/Item_category.dart';

import '../utils/helpers/api.dart';
import '../widgets/custom_container.dart';

class AddCategory extends ConsumerStatefulWidget {

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final categoryName = TextEditingController();

  Future addCategory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();


    var data = await postApi("item-category/add",
        {'vendor_id': preferences.getInt('vnd').toString(),
          'name':categoryName.text});

    if (data['result'] == true) {

      Fluttertoast.showToast(
          msg: "${data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      categoryName.clear();
      Navigator.of(context).pop(true);
    }else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 180,
              child: CustomContainer(
                child: TextFormField(
                  controller: categoryName,
                  maxLines: 3,
                  minLines: 2,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.drive_file_rename_outline),
                    hintText: 'Product Category name',
                    labelText: 'Category name *',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              // height: 140,
              child: CustomContainer(
                  child: Column(
                    children: [
                       Container(
                        height: 165,
                        width: 230,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.pink[200]),
                          ),
                          onPressed: () => null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 76,
                              ),
                              Text(
                                "Category Image",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.ubuntu(fontSize: 22),
                              )
                            ],
                          ),
                        ),
                      )

                    ],
                  )),
            ),
            Container(
              alignment: Alignment.center,
              margin:
              EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 5),
              child: ElevatedButton(
                onPressed: () {
                  // ref.watch(itemCategoryProvider).getItemCategories();
                  addCategory();
                }, child: Text("Add category"),

              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ],),
    );
  }
}
