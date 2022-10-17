import 'dart:convert';

import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/MessageModel.dart';
import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/Services/MessageServices/MessageResponse.dart';
import 'package:chat_app/socketServices/socketservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../Models/User.dart';
import '../../main.dart';
class MessageServices extends GetxController{



  RxList<MessageModel> messages = RxList.empty();
  RxString currentuser="".obs;
  RxString chatId="".obs;
  Rx<User> user=User(username: "", email: "", phone: "", countrycode: "").obs;
  RxBool issender=false.obs;
    final scrollController = ScrollController();

    @override
  void onInit() {
    super.onInit();
    chatId.value=Get.arguments[1].toString();
    user.value=Get.arguments[0];
    update();
    print("chatId.value ${chatId.value}");
    getAllChatMessages(chatId.value);
    connectToSocket();
    getuser();
 
  }
  
 void connectToSocket() async{
   
 
   Socket socket=Get.find<SocketServices>().socket;
  socket.connect();

 socket.emit("JoinChat",chatId.value);
  socket.on("JoinChat",(returneddata){
    
    print(returneddata);
   });
    socket.on("message", (message) {
      appendMessage(message);

    
  });
  }

 
  
   Future getAllChatMessages(String chatId)async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String? token=sharedPreferences.getString("token");
  print("chat id $chatId");
    String messageUrl="${await Constants().detectDevice()}/message/$chatId";
   
 
  final response=await http.get(Uri.parse(messageUrl),headers: {
     "Content-Type": "application/json",
     "Authorization":"Bearer $token"
  });
  print(response.statusCode);
  if(response.statusCode==200){
    final data=messageResponseFromJson(response.body);
    messages.value=data.messages;

  }
  else{
   print(jsonDecode(response.body)["msg"]);
  }
}  



  

    Future getuser() async {
    SharedPreferences sharedprefs = await SharedPreferences.getInstance();

  
 
  if(sharedprefs.getString("ID")!=null){
     currentuser.value = sharedprefs.getString("ID")!;
  }
          
 
  }

    void appendMessage(data ) {
    Map<String,dynamic>message=data as Map<String,dynamic>;
 MessageModel messageModel=MessageModel.fromJson(message );



        messages.add(messageModel);
        
       
    }
          

      
  
  }
