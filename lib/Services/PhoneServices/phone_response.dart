import 'dart:convert';

import 'package:chat_app/Models/user.dart';

PhoneResponse phoneResponseFromJson(String str)=>PhoneResponse.fromJson(json.decode(str)["user"]as List);
class PhoneResponse{

  late List< User> user;
  PhoneResponse.fromJson(List<dynamic> json):
  user=json.map((e) => User.fromJson(e)).toList();
 


}