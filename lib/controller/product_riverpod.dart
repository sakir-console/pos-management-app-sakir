import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/models/items_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:http/http.dart' as http;

import '../model/counter_model.dart';
import '../models/item_category.dart';

class ProductRiverpod extends ChangeNotifier {
  List<ItemModel> products = [];
  List<ItemModel> favorites = [];
  List<ItemModel> basketProducts = [];
  List counterItems = [];

  List items = [];
  List itemsX = [];
  Map<String, dynamic> counterData = {};

  double totalPrice = 0.0;

  /*Future getCounterItems(int catId) async {
    try {
      final response = await http
          .get(Uri.parse("http://127.0.0.1:8000/api/v1/items?vnd=2&cat=$catId"));
      final data = jsonDecode(response.body)['data'];
      List<ItemModel> catItems = [];
      for (int i = 0; i < data.length; i++) {
        catItems.add(ItemModel.fromMap(data[i]));
      }
      counterItems.addAll(catItems);
    } catch (e) {
      throw Exception(e);
    }
    notifyListeners();
  }
*/

  void setFavorite(ItemModel model) {
    if (model.isFav) {
      model.isFav = false;
      favorites.remove(model);
      notifyListeners();
    } else {
      model.isFav = true;
      favorites.add(model);
      notifyListeners();
    }
  }

  void addedBasket(ItemModel model,[Quantity? selectedQuantity]) {
    var itemData = {
      'id': model.id,
      'name': model.title,
      //'price': selectedQuantity != null ? selectedQuantity.price : model.price,
      'price': selectedQuantity != null ? selectedQuantity.discountPrice??selectedQuantity.price : model.priceDiscounted??model.price,
      'qty': 1,
      'size': selectedQuantity != null ? selectedQuantity.qty : model.qtys.first.qty
    };

    itemsX.add(itemData);
    addTotalPrice();

    if (basketProducts.contains(model)) {
      print('contains-----------');

      model.qty = model.qty + 1;
      //addTotalPrice(model);
      notifyListeners();
    } else {
      // First adding...
      basketProducts.add(model);

      model.qty = model.qty + 1;
     // addTotalPrice(model);
      basketProducts.forEach((item) {
        print('id: ${item.id}, title: ${item.title}');

        items.add({
          'id': item.id,
          'name': item.title,
          'price': item.price,
          'qty': item.qty

          // '${menu[index]['id']}': checked[index]
        });
      });
      notifyListeners();
    }
  }

  void decrementQty(ItemModel model,[Quantity? selectedQuantity]) {
    // Find the index of the item in itemsX
    var index = itemsX.indexWhere((item) => item['id'] == model.id &&
        (selectedQuantity != null ? item['size'] == selectedQuantity.qty : item['size'] == model.qtys.first.qty));

    // If the item is found and its quantity is greater than 0, decrement the quantity
    if (index != -1 && itemsX[index]['qty'] > 0) {
      itemsX[index]['qty']--; // Decrement the quantity
      // Update the total price accordingly if necessary

      // Deduct the price of the item from the total price
      totalPrice -= itemsX[index]['price'];

      // If the quantity becomes zero, remove the item from itemsX
      if (itemsX[index]['qty'] == 0) {
        itemsX.removeAt(index);
      }
      notifyListeners(); // Notify listeners about the change
    }


    model.qty = model.qty - 1;
    //totalPrice -= model.price;
    //print(model.qty);
    if (model.qty == 0) {
      basketProducts.remove(model);
    }
    print(totalPrice);
    notifyListeners();
  }

  void deleteBasket(ItemModel model) {
    print('clicked');

    deleteTotalPrice(model);
    // Remove the item with the matching id from itemsX
    itemsX.removeWhere((item) => item['id'] == model.id);

    basketProducts.remove(model);
    model.qty = 0;
    notifyListeners();
  }

  void deleteBasketAll() {
    List modelAll = basketProducts.toList();
    for (int i = 0; i < modelAll.length; i++) {
      basketProducts.remove(modelAll[i]);
      modelAll[i].qty = 0;
    }
    print('Deleted all');
    itemsX.clear();
    totalPrice = 0;
    notifyListeners();
  }

  void clearCounter() {
    basketProducts.clear();
    products.clear();
    //init();
    totalPrice = 0;
    notifyListeners();
  }

  void init() {
    totalPrice = 0;
    notifyListeners();
  }

  void addTotalPrice() {
    totalPrice = itemsX.fold(0, (total, item) => total + item['price']);
  }

  void finalData() async{
    // Create a map to store aggregated quantities for each item
    Map<String, Map<String, dynamic>> aggregatedItems = {};

    // Iterate over itemsX and aggregate quantities
    itemsX.forEach((item) {
      // Generate a unique key using item id and size
      String key = '${item['id']}-${item['size']}';
      if (aggregatedItems.containsKey(key)) {
        // If the key exists, increment the quantity
        aggregatedItems[key]!['qty'] += 1;
      } else {
        // If the key doesn't exist, add the item to the map
        aggregatedItems[key] = {
          'id': item['id'],
          'name': item['name'],
          'price': item['price'],
          'qty': 1, // Initialize quantity to 1
          'size': item['size']
        };
      }
    });

    // Convert the map values back to a list
    List<Map<String, dynamic>> aggregatedItemList = aggregatedItems.values.toList();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    counterData["vendor_id"] =  preferences.getInt('vnd').toString();
    counterData["price"] = totalPrice;
    counterData["items"] = aggregatedItemList;


    print("counterData: $counterData");
  }


  void deleteTotalPrice(ItemModel model) {
    // Find all items with the specified ID and sum their prices
    var sumOfDeletedItemPrices = itemsX
        .where((item) => item['id'] == model.id)
        .map<double>((item) => item['price'])
        .fold(0.0, (sum, price) => sum + price);

    // Deduct the sum from the total price
    totalPrice -= sumOfDeletedItemPrices;
  }




/*  void init() {
    for (int i = 0; i < 30; i++) {
      products.add(
        ItemModel(
          id: i,
          isFav: false,
          qty: 0,
          title: "Xiaomi ${i + 1}",
          description: "${8 + (i * 2)} MP kameralı ve 55${i * 10} mAh batarya",
          price: 6000.0 + (i * 10),
          imagePath: i.randomImage(),
        ),
      );
    }
  }*/
}
