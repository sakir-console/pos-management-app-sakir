import 'package:grock/grock.dart';
import 'package:flutter/material.dart';

class ItemModel {
  int id;
  String title;
  double rating;
  bool isFav;
  int qty;
  double price;
  String imagePath;

  String? discount;
  int? priceDiscounted;
  String? priceMax;
  String? priceMin;

  int? sold;
  String description;
  String ingredients;

  List<Category> cats;
  List<Quantity> qtys;
  List<String> imgs;
  ItemModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.isFav,
    required this.qty,
    required this.price,
    required this.imagePath,
    required this.discount,
    required this.priceDiscounted,
    required this.priceMax,
    required this.priceMin,
    required this.sold,
    required this.description,
    required this.ingredients,
    required this.cats,
    required this.qtys,
    required this.imgs,
  });

  factory ItemModel.fromMap(Map<String, dynamic> json) {
    //print('JSON data: json');
    return ItemModel(
      id: json["id"],
      title: json["title"],
      rating: json["rating"].toDouble(),
      isFav: false,
      qty: 0,
      price: double.parse(json["price_min"]),
      imagePath: 'https://random.imagecdn.app/300/350',
      discount: json["discount"],
      priceDiscounted: json["price_discounted"],
      priceMax: json["price_max"],
      priceMin: json["price_min"],
      sold: json["sold"],
      description: json["description"],
      ingredients: json["ingredients"],
      cats: List<Category>.from(json["cats"].map((x) => Category.fromJson(x))),
      qtys: List<Quantity>.from(json["qtys"].map((x) => Quantity.fromJson(x))),
      imgs: List<String>.from(json["imgs"].map((x) => x["image"])),
    );
  }
}

class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
    );
  }
}

class Quantity {
  String qty;
  double price;
  bool dcntStatus;
  double? discountTk;
  double? discountPercentage;
  double? discountPrice;

  Quantity({
    required this.qty,
    required this.price,
    required this.dcntStatus,
    required this.discountTk,
    required this.discountPercentage,
    required this.discountPrice,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) {
    return Quantity(
      qty: json["qty"],
      price: double.parse(json["price"]), // Parse the price string to double
      dcntStatus: json["dcnt_status"],
      discountTk: json["discount_tk"]?.toDouble(), // Convert int? to double?
      discountPercentage: json["discount_%"]?.toDouble(), // Convert int? to double?
      discountPrice: json["discount_price"]?.toDouble(), // Convert int? to double?
    );
  }
}


class CCModel {
  int id;
  String title;
  int count;
  double price;
  String size;


  CCModel({
    required this.id,
    required this.title,
    required this.count,
    required this.price,
    required this.size,

  });

}

