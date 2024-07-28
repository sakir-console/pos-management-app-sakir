import 'dart:convert';

import 'package:pos_by_sakir/models/items_model.dart';
import 'package:pos_by_sakir/riv/model/data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pos_by_sakir/utils/helpers/api.dart';



class VendorRepository {

  Future vendorList() async {
    var data = await getApi("vendor-list" );
    return data;
  }


  Future<List<DataModel>> getLogin() async {
    try {
      List<DataModel> listDataModel = [];

      final response = await http
          .get(Uri.parse("xxxx"));
      var data = jsonDecode(response.body)['data'];

      for (int i = 0; i < data.length; i++) {
        listDataModel.add(DataModel.fromMap(data[i]));
      }
      return listDataModel;
    } catch (e) {
      throw Exception(e);
    }
  }


  Future<List<ItemModel>> getCategoryItems(int catId) async {
    try {

      final response = await http
          .get(Uri.parse("https://amarbangabandhu.app/items"));
      var data = jsonDecode(response.body)['data'];
      List<ItemModel> listItem = [];

      for (int i = 0; i < data.length; i++) {
        listItem.add(ItemModel.fromMap(data[i]));
      }
      return listItem;
    } catch (e) {
      throw Exception(e);
    }
  }




}
