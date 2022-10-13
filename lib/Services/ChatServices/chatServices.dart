import 'dart:convert';

import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Services/ChatServices/chatresponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatServices extends GetxController{


  Future createChat (String recieverid)async{

final request={"userId":recieverid};

String createChatapi="${await Constants().detectDevice()}/chat/";

SharedPreferences sharedprefs=await SharedPreferences.getInstance();
String? token=sharedprefs.getString("token");



  final response=await http.post(Uri.parse(createChatapi),body: jsonEncode(request),headers: {
  "Content-Type": "application/json",
  "Authorization":"Bearer $token"
  });
  if(response.statusCode==200){
   final data=json.decode(response.body)["chatId"];
   return [true,data];
  }
  else{
    
    final data= jsonDecode(response.body)["msg"];
    return[false,data] ;
  }
 

  }

  Future getAllChats()async{

    String createChatapi="${await Constants().detectDevice()}/chat/";
SharedPreferences sharedprefs=await SharedPreferences.getInstance();
String? token=sharedprefs.getString("token");


 

  
  

  try {
  final response=await http.get(Uri.parse(createChatapi),headers: {
   "Content-Type": "application/json",
   "Authorization":"Bearer $token"
   });
  
   if(response.statusCode==200){
    final data=chatResponseFromJson(response.body);
  
  return data.chats;
   
   }
   else{
    return jsonDecode(response.body)["msg"];
   }
} catch (e) {
 print(e.toString());
}




}
}