class ProductModel {
  int id;
  bool isFav;
  int qty;
  String imagePath;
  String title;
  double price;
  String description;

  ProductModel({
    required this.id,
    required this.isFav,
    required this.qty,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.description,
  });
}
