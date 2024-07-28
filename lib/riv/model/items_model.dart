class ItemModel {
  int id;
  String title;
  int rating;
  String discount;
  String priceMax;
  String priceMin;
  int priceDiscounted;
  int sold;
  String description;
  String ingredients;
  ItemModel({
      required this.id,
      required this.title,
      required this.rating,
      required this.discount,
      required this.priceMax,
      required this.priceMin,
      required this.priceDiscounted,
      required this.sold,
      required this.description,
      required this.ingredients});


  factory ItemModel.fromMap(Map<String, dynamic> json) {
    return ItemModel(
      id: json["id"],
      title: json["title"],
      rating: json["rating"],
      discount: json["discount"],
      priceMax: json["price_max"],
      priceMin: json["price_min"],
      priceDiscounted: json["price_discounted"],
      sold: json["sold"],
      description: json["description"],
      ingredients: json["ingredients"],
    );
  }


}
