

class User {
   String id;
  late String username;
  late String email;
  late String password;
  late String phone;
  late String countrycode;

  User({
    this.id="",
    required this.username,
    required this.email,
     this.password="",
    required this.phone,
    required this.countrycode,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    final id=json["_id"];
   final username = json["username"];
    final email = json["email"];
   final phone = json["phone"];
   final countrycode = json["countrycode"];

    return User(
      id: id,
        username: username,
        email: email,
        phone: phone,
        countrycode: countrycode,
    );
  }

  Map<String, dynamic> userToJson() => {
        "username": username,
        "password": password,
        "email": email,
        "phone": phone,
        "countrycode": countrycode,
      };
}
