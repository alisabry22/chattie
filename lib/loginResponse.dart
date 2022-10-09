import 'dart:convert';

import 'package:chat_app/usermodels/UserModel.dart';

class loginResponse {

  late String msg;
   late UserModel userModel;
  late String token;
  
  loginResponse({
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

  factory loginResponse.fromMap(Map<String, dynamic> map) {
    return loginResponse(
      msg:  map["msg"],
      userModel:  UserModel.fromJson(map["user"]),
      token:  map["token"],
    );
  }

   toJson() => json.encode(toMap());

  factory loginResponse.fromJson(String source) => loginResponse.fromMap(json.decode(source));
}
