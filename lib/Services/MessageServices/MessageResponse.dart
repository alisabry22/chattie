import 'dart:convert';

import 'package:chat_app/Models/MessageModel.dart';

class MessageResponse{


late  List<MessageModel> messages;

MessageResponse.fromJson(List<dynamic>json):
messages=json.map((e) => MessageModel.fromJson(e as Map<String,dynamic>)).toList();
}

MessageResponse messageResponseFromJson(String str)=>MessageResponse.fromJson(jsonDecode(str)["messages"] as List);