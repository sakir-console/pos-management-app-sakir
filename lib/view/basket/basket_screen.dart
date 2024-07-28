import 'dart:convert';

import 'package:pos_by_sakir/controller/riverpod_management.dart';
import 'package:pos_by_sakir/providers/shared_provider.dart';
import 'package:pos_by_sakir/view/utilities/constants/constants.dart';
import 'package:pos_by_sakir/view/utilities/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grock/grock.dart';

import '../../models/items_model.dart';
import '../../providers/Counter.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({Key? key}) : super(key: key);
  void showCounterDetailsDialog(BuildContext context, Map<String, dynamic> counterData) {
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
    final vndId = ref.watch(vendorIdProvider);
    var product = ref.watch(productRiverpod);
    return Scaffold(
      body: product.basketProducts.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Constants.emptyBasketMsg),
                  OutlinedButton(
                    onPressed: () {
                      ref.read(bottomNavbarRiverpod).setCurrentIndex(0);
                    },
                    child: Text(Constants.goToProducts),
                  )
                ],
              ),
            )
          : ListView(
              children: [
                GrockList(
                  shrinkWrap: true,
                  itemCount: product.basketProducts.length,
                  scrollEffect: const NeverScrollableScrollPhysics(),
                  padding: [20, 10].horizontalAndVerticalP,
                  itemBuilder: (context, index) {
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            autoClose: true,
                            flex: 1,
                            onPressed: (value) {
                              product
                                  .deleteBasket(product.basketProducts[index]);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ProductWidget(
                        productRiverpod: product,
                        removeItem: () => product.deleteBasket(product.basketProducts[index]),
                        decrementQty: (Quantity selectedQuantity) =>
                            product.decrementQty(product.basketProducts[index],selectedQuantity),
                        productModel: product.basketProducts[index],
                        setFav: () =>
                            product.setFavorite(product.basketProducts[index]),
                        setBasket: (Quantity selectedQuantity) => product.addedBasket(product.basketProducts[index],selectedQuantity),
                      vndId: vndId.toString(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: 20.horizontalP,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Constants.totalPrice}: ${product.totalPrice} ৳",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      OutlinedButton(
                        onPressed: () {



                          product.finalData(); // This generates counterData
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                  future: addCounterData(product.counterData),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    } else {
                                      if (snapshot.hasError) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Failed to connect to the server.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.hasData) {
                                        var responseData = jsonDecode(snapshot.data.body);
                                        if (responseData['result'] == true) {
                                          return AlertDialog(
                                            title: Text('Counter Added Successfully'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Counter Code: ${responseData['data']['counter_code']}'),
                                                Text('Invoice: ${responseData['data']['invoice']}'),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  product.deleteBasketAll();
                                                  Navigator.pop(context);},
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(responseData['message']),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        }
                                      } else {
                                        // Handle the case when snapshot.data is null
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Failed to retrieve data from the server.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
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
                          });

                        },
                        child: Text(Constants.order),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
