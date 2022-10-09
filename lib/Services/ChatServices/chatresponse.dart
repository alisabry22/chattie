import 'dart:convert';

import 'package:chat_app/Models/ChatModel.dart';

class ChatResponse{
late List<ChatModel> chats;

ChatResponse({
  required this.chats
});

ChatResponse.fromJson(List<dynamic>json):
chats=json.map((e) => ChatModel.fromJson(e as Map<String,dynamic>)).toList();

}

ChatResponse chatResponseFromJson(String str)=>ChatResponse.fromJson(jsonDecode(str)["chat"] as List);