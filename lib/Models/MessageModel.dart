
import 'package:chat_app/Models/User.dart';

class MessageModel{

 late String id;
 late String message;
  late User senderData;
  late String chatId;

MessageModel({
 required this.id,
  required this.message,
  required this.senderData,
  required this.chatId,
});

 MessageModel.fromJson(Map<String,dynamic>json):
id=json["_id"],
message=json["message"],
senderData=User.fromJson(json["sender"]),
chatId=json["chat"];

}

