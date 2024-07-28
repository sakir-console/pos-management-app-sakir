class DataModel {
  int id;
  String name;
  int vendorId;
  dynamic createdAt;
  dynamic updatedAt;

  DataModel({required this.id, required this.name, required this.vendorId, this.createdAt, this.updatedAt});


  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      id: map["id"],
      name: map["name"],
      vendorId: map["vendor_id"],
      createdAt: map["created_at"],
      updatedAt: map["updated_at"],
    );
  }


}
