import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/models/item_category.dart';
import 'package:pos_by_sakir/models/items_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pos_by_sakir/utils/constants.dart';
import 'package:pos_by_sakir/utils/helpers/api.dart';

//Categories
final itemCategoryProvider =
    FutureProvider<List<ItemCategoryModel>>((ref) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await postApi(
        "item-categories", {'vendor_id': preferences.getInt('vnd').toString()});

    final data = response['data'];
    return data
        .map<ItemCategoryModel>((json) => ItemCategoryModel.fromJson(json))
        .toList();
  } catch (e) {
    throw Exception(e);
  }
});

//Category Items
final itemProvider =
    FutureProvider.family<List<ItemModel>, int>((ref, catID) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final response = await getApi(
        "items?vnd=${preferences.getInt('vnd').toString()}&cat=$catID");

    final data = response['data'];
    List<ItemModel> listItem = [];

    for (int i = 0; i < data.length; i++) {
      listItem.add(ItemModel.fromMap(data[i]));
    }

    return listItem;
    //return data.map<ItemModel>((json) => ItemModel.fromMap(json)).toList();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    throw Exception(e);
  }
});

//Add to Cunter
Future addCounterData(Map<String, dynamic> counterData) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    // Set the headers
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json;charset=UTF-8",
      "Charset": "utf-8"
    };

    final response = await http.post(
      Uri.parse("${API.HOST}${API.Version}counter/add"),
      headers: headers,
      body: jsonEncode(counterData),
    );
    debugPrint("${API.HOST}${API.Version}counter/add");
    //debugPrint("$headers");

    if (response.statusCode == 200) {
      debugPrint("Server response: ${response.body}");
    } else {
      debugPrint(
          "Failed to add counter data. Status code: ${response.statusCode}");
      debugPrint("Server response: ${response.body}");
    }
    return response;
  } catch (e) {
    debugPrint("Error adding counter data: $e");
  }
}
