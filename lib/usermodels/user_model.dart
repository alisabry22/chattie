import 'dart:convert';

class UserModel {

  late String email,username,password,phone,id;
  
  UserModel({
    required this.email,
    required this.username,
    required this.password,
    required this.phone,
   
  });

  Map<String, dynamic> toJson() {
    return {
      "email":email,
      "username":username,
      "password":password,
      "phone":phone
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      email:map["email"],
      username:map["username"],
      password:map["password"],
      phone:map["phone"]
    );
  }

  String usertoJson(UserModel userModel) => json.encode(userModel.toJson());

  UserModel userFromJson(String source) => UserModel.fromJson(json.decode(source));
}
