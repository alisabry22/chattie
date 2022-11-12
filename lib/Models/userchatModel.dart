import 'dart:convert';

import 'package:chat_app/Models/chat_model.dart';

class userChatModel {
  String id, username, email, phone, countrycode, profilephoto;
  List<ChatModel> chats;

  userChatModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.countrycode,
    required this.profilephoto,
    required this.chats,
  });

  factory userChatModel.fromJson(Map<String, dynamic> json) {
    final id = json["_id"] ?? "";
    final username = json["username"] ?? "";
    final email = json["email"] ?? "";
    final phone = json["phone"] ?? "";
    final countrycode = json["countrycode"] ?? "";
    final profilephoto = json["profilephoto"] ?? "";
    final demochats=json["chats"] as List<dynamic>;
    final chats = demochats.isNotEmpty?demochats.map<ChatModel>((e) =>ChatModel.fromJson(e)).toList():<ChatModel>[];

    return userChatModel(
        id: id,
        username: username,
        email: email,
        phone: phone,
        countrycode: countrycode,
        profilephoto: profilephoto,
        chats: chats);
  }
}

userChatModel userChatModelfromJson(String str)=>userChatModel.fromJson(jsonDecode(str)["userdata"]);
