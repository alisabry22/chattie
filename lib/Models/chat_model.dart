import 'dart:convert';

import 'package:chat_app/Models/message_model.dart';
import 'package:chat_app/Models/user.dart';

class ChatModel {
  late String id, chatName;
  late bool isgroupChat;
  late List<User> users;
   MessageModel? messageModel;

  ChatModel({
    required this.id,
    required this.chatName,
    required this.isgroupChat,
    required this.users,
    required this.messageModel,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final id = json["_id"] as String;
    final chatName = json["chatName"] as String; 
    final isgroupChat = json["isgroupChat"] as bool;
     final usersdata = json["users"] as List<dynamic>;
     final users = usersdata.isNotEmpty? usersdata.map<User>((e) => User.fromJson(e)).toList():<User>[];
     final messagemodel=json["latestMessage"]!=null?MessageModel.fromJson(json["latestMessage"]):null  ;
     
    return ChatModel(
        id: id, chatName: chatName, isgroupChat: isgroupChat,users: users,messageModel: messagemodel);
  }
}

ChatModel chatModelfromJson(String str) =>
    ChatModel.fromJson(jsonDecode(str)["chatId"]);
