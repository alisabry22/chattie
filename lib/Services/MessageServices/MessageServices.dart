import 'dart:convert';

import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Services/MessageServices/MessageResponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class MessageServices extends GetxController{



  Future getAllChatMessages(String chatId)async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String? token=sharedPreferences.getString("token");

    String messageUrl="${Constants().url}/message/$chatId";
   
  try {
  final response=await http.get(Uri.parse(messageUrl),headers: {
     "Content-Type": "application/json",
     "Authorization":"Bearer $token"
  });
  
  if(response.statusCode==200){
    final data=messageResponseFromJson(response.body);
    return data.messages;
  }
  else{
    return jsonDecode(response.body)["msg"];
  }
}  catch (e) {
  print(e.toString());
}



  }
}