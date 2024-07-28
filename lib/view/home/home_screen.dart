import 'dart:convert';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:pos_by_sakir/controller/riverpod_management.dart';
import 'package:pos_by_sakir/models/items_model.dart';
import 'package:pos_by_sakir/providers/Counter.dart';
import 'package:pos_by_sakir/providers/shared_provider.dart';

import 'package:pos_by_sakir/view/utilities/widgets/product_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grock/grock.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vertical_tabs_flutter/vertical_tabs.dart';

import '../../models/item_category.dart';
import '../basket/basket_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  void showCounterDetailsDialog(
      BuildContext context, Map<String, dynamic> counterData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Counter Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Counter Code: ${counterData['counter_code']}'),
            Text('Invoice: ${counterData['invoice']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(itemCategoryProvider);
    final vndId = ref.watch(vendorIdProvider);

    var watch = ref.watch(productRiverpod);
    var read = ref.read(productRiverpod);

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: ElevatedButton(
                  child: const Text(
                    'Cash Memo',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onPressed: () => showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const BasketScreen(),
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                  child: const Text(
                    'RESET',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onPressed: () {
                    watch.deleteBasketAll();
                  },
                ),
              ),
              Container(
                child: ElevatedButton(
                  child: const Text(
                    'Total',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onPressed: () {
                    Alert(
                      useRootNavigator: false,
                      context: context,
                      title: "Counter",
                      desc: "Total: ${watch.totalPrice} ৳",
                    ).show();
                  },
                ),
              ),
              Container(
                child: ElevatedButton(
                    child: Icon(Icons.online_prediction_sharp),
                    onPressed: () {
                      read.finalData(); // This generates counterData
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        if (watch.totalPrice == 0) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Select item to calculate.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                future: addCounterData(watch.counterData),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    if (snapshot.hasError) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                            'Failed to connect to the server.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.hasData) {
                                      var responseData =
                                          jsonDecode(snapshot.data.body);
                                      if (responseData['result'] == true) {
                                        return AlertDialog(
                                          title: Text('Counter Added'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Counter Code: '),
                                                  Text(
                                                    '${responseData['data']['counter_code']}',
                                                    style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                        fontSize:
                                                            26, // Adjust the font size as needed
                                                        fontWeight: FontWeight
                                                            .bold, // Make the text bold for better visibility
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  'Invoice: ${responseData['data']['invoice']}'),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                watch.deleteBasketAll();
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content:
                                              Text(responseData['message']),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      }
                                    } else {
                                      // Handle the case when snapshot.data is null
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                            'Failed to retrieve data from the server.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        }
                      });
                    }),
              ),
            ],
          ),
          Expanded(
              child: categories.when(data: (data) {
            // print(watch.getCounterItems(9));
            return VerticalTabs(
              tabsWidth: 100,
              tabs: List<Tab>.generate(data.isEmpty ? 0 : data.length,
                  (int index) {
                return Tab(
                    icon: Icon(Icons.phone),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(data[index].name),
                    ));
              }),
              contents: List<Widget>.generate(data.isEmpty ? 0 : data.length,
                  (int index) {
                return ref.watch(itemProvider(data[index].id)).when(
                    data: (item) {
                  return GridView.builder(
                    padding: [4, 5].horizontalAndVerticalP,
                    itemCount: item.length,
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 0.95),
                    itemBuilder: (context, index) {
                      return ProductWidget(
                        decrementQty: (Quantity selectedQuantity) =>
                            read.decrementQty(item[index], selectedQuantity),
                        productModel: item[index],
                        setFav: () => read.setFavorite(item[index]),
                        setBasket: (Quantity selectedQuantity) =>
                            read.addedBasket(item[index], selectedQuantity),
                        removeItem: () => read.deleteBasket(item[index]),
                        productRiverpod: read,
                        vndId: vndId.toString(),
                      );
                    },
                  );
                }, error: ((error, stackTrace) {
                  return Text(error.toString());
                }), loading: () {
                  return const Center(
                      child: Scaffold(
                          body: SizedBox(
                              width: 30, child: CircularProgressIndicator())));
                });
              }),
            );
          }, error: ((error, stackTrace) {
            return Text(error.toString());
          }), loading: () {
            return const Center(
                child: SizedBox(width: 50, child: CircularProgressIndicator()));
          })),
          Container(
            padding: EdgeInsets.all(7),
            height: 50,
            child: Center(
                child: Text(
              "Total: ${watch.totalPrice} ৳",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
            )),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.deepOrange[200],
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
          )
        ],
      ),
    );
  }
}
