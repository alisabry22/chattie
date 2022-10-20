import 'dart:convert';

import 'package:chat_app/usermodels/user_model.dart';

class LoginResponse {

  late String msg;
   late UserModel userModel;
  late String token;
  
  LoginResponse({
  required  this.msg,
  required this.userModel,
  required this.token,
  });

  


 

  Map<String, dynamic> toMap() {
    return {
      'msg': msg,
      'userModel': userModel,
      'token': token,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      msg:  map["msg"],
      userModel:  UserModel.fromJson(map["user"]),
      token:  map["token"],
    );
  }

   toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) => LoginResponse.fromMap(json.decode(source));
}
