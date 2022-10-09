import 'dart:convert';

import 'package:chat_app/Models/User.dart';

phoneResponse phoneResponseFromJson(String str)=>phoneResponse.fromJson(json.decode(str)["user"]as List);
class phoneResponse{

  late List< User> user;
  phoneResponse.fromJson(List<dynamic> json):
  user=json.map((e) => User.fromJson(e)).toList();
 


}