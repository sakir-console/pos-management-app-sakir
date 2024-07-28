class ItemCategoryModel {
  int id;
  String name;
  int vendorId;

  ItemCategoryModel(
      {required this.id, required this.name, required this.vendorId});

  factory ItemCategoryModel.fromJson(Map<String, dynamic> json) {
    return ItemCategoryModel(
        id: json["id"],
        name: json["name"],
        vendorId: json["vendor_id"]);
  }
}
