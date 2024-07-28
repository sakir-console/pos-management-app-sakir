import 'package:pos_by_sakir/controller/riverpod_management.dart';
import 'package:pos_by_sakir/models/items_model.dart';
import 'package:pos_by_sakir/providers/Counter.dart';
import 'package:pos_by_sakir/providers/shared_provider.dart';

import 'package:pos_by_sakir/view/utilities/widgets/product_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grock/grock.dart';
import 'package:vertical_tabs_flutter/vertical_tabs.dart';

import '../../models/item_category.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
            children: [
              Container(
                child: ElevatedButton(
                  child: Text(
                    'kmm',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  onPressed: () => read.clearCounter(),
                ),
              ),
              Container(
                child: ElevatedButton(
                  child: const Text(
                    'Print',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onPressed: () {},
                ),
              ),
              Container(
                child: ElevatedButton(
                  child: Icon(Icons.calculate_outlined),
                  onPressed: () => read.finalData(),
                ),
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
                    padding: [20, 10].horizontalAndVerticalP,
                    itemCount: item.length,
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 0.95),
                    itemBuilder: (context, index) {

                      return ProductWidget(
                        decrementQty: () =>
                            read.decrementQty(item[index]),
                        productModel: item[index],
                        setFav: () => read.setFavorite(item[index]),
                        setBasket: () =>
                            read.addedBasket(item[index]),
                        removeItem: () =>
                            read.deleteBasket(item[index]),
                        vndId: vndId.toString(),
                      );
                    },
                  );
                }, error: ((error, stackTrace) {
                  return Text(error.toString());
                }), loading: () {
                  return const Center(
                      child: SizedBox(
                          width: 50, child: CircularProgressIndicator()));
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
