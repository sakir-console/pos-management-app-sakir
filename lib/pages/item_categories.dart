import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/repositories/Item_category.dart';

import '../utils/constants.dart';
import '../utils/helpers/api.dart';
import '../widgets/custom_listView_container.dart';
import 'add_item_category.dart';

class ViewCategory extends ConsumerWidget {
  const ViewCategory({super.key});

  //Delete Category
  Future deleteCategory(int catId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final vnd_id = preferences.getInt('vnd').toString();
    var data = await postApi(
        "item-category/delete", {'cat_id': '$catId', 'vnd_id': vnd_id});
    if (data['data'] != null) {
      Fluttertoast.showToast(
          msg: data['result'] ? data['message'] : data['data'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: data['result'] ? Colors.teal : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(responseItemCategories);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(secondary: Colors.blueGrey, surface: Colors.blueAccent),
          fontFamily: 'Raleway'),
      home: Scaffold(
          backgroundColor: Color(0xffdee4eb),
          appBar: AppBar(
            title: Text("Category list",
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
                        Icons.library_add_rounded,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                onPressed: () => showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddCategory(),
                ).then((value) {
                  if (value == true) {}
                }),
              ),
            ],
          ),
          body: categories.when(
              data: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return ListViewContainer(
                        child: ListTile(
                          title: Text(
                            data[i].name,
                            style: GoogleFonts.ubuntu(
                                fontSize: 20, color: Colors.teal),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateCategory(
                                        data[i].id, data[i].name)));
                          },
                          // subtitle: Text('subtitle'),
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal[200],
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )),
                          ),
                          trailing: RawMaterialButton(
                            onPressed: () {
                              CoolAlert.show(
                                onConfirmBtnTap: () {
                                  deleteCategory(data[i].id);
                                },
                                context: context,
                                type: CoolAlertType.confirm,
                                text: 'Do you want to delete',
                                confirmBtnText: 'Yes',
                                cancelBtnText: 'No',
                                confirmBtnColor: Colors.green,
                              );
                            }, //do your action
                            elevation: 1.0,
                            constraints:
                                BoxConstraints(), //removes empty spaces around of icon
                            shape: CircleBorder(), //circular button
                            fillColor: Color(0xffff6464), //background color
                            splashColor: Colors.amber,
                            highlightColor: Colors.amber,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(8),
                          ),
                        ),
                      );
                    });
              },
              error: (error, stackTrace) =>
                  Scaffold(body: Text(error.toString())),
              loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator())))),
    );
  }

  updateCategory(categori, categori2) {}
}
