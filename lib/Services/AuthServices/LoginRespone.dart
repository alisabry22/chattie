import 'dart:convert';

import 'package:chat_app/Models/User.dart';

class LoginResponse{

  late User user;
  late String token;
  LoginResponse({
    required this.user,
    required this.token,
  });

  LoginResponse.FromJson(Map<String,dynamic>json):
  user=User.fromJson(json["user"]),
  token=json["token"];

Map<String,dynamic>toJson()=>{
"user":user.userToJson(),
"token":token,

};



}
LoginResponse loginResponseFromJson(String str)=>LoginResponse.FromJson(json.decode(str));