class User {
  String first_name;
  String last_name;
  User({required this.first_name, required this.last_name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(first_name: json['first_name'], last_name: json['last_name']);
  }
}
