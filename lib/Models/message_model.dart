

class MessageModel{

 late String id;
 late String message;
  late String senderId;
  late String chatId;

MessageModel({
 required this.id,
  required this.message,
  required this.senderId,
  required this.chatId,
});

 MessageModel.fromJson(Map<String,dynamic>json):
id=json["_id"],
message=json["message"],
senderId=json["sender"],
chatId=json["chat"];

}

