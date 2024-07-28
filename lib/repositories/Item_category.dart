import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/models/item_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pos_by_sakir/utils/helpers/api.dart';

final responseItemCategories = FutureProvider((ref) async {
  return ref.watch(itemCategoryProvider).getItemCategories();
});

final itemCategoryProvider =
    Provider<ItemCategoryRepository>((ref) => ItemCategoryRepository());

class ItemCategoryRepository {
  Future<List<ItemCategoryModel>> getItemCategories() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final response = await postApi("item-categories",
          {'vendor_id': preferences.getInt('vnd').toString()});

      final data = response['data'];
      return data
          .map<ItemCategoryModel>((json) => ItemCategoryModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
