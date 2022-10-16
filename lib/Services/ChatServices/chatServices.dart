import 'dart:convert';

import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/MessageModel.dart';
import 'package:chat_app/Services/ChatServices/chatresponse.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/ChatModel.dart';
import '../../main.dart';

class ChatServices extends GetxController{

 RxList<ChatModel>chats=<ChatModel>[].obs;
  RxString currentUserID="".obs;
 @override
  void onInit() {
    super.onInit();
    getAllChats();
    socketservice();
    getCurrentUser();
  }
  Future  createChat (String recieverid)async{

final request={"userId":recieverid};
String createChatapi="${await Constants().detectDevice()}/chat/";

SharedPreferences sharedprefs=await SharedPreferences.getInstance();
String? token=sharedprefs.getString("token");



  try {
  final response=await http.post(Uri.parse(createChatapi),body: jsonEncode(request),headers: {
  "Content-Type": "application/json",
  "Authorization":"Bearer $token"
  });
    print(response.body);
  if(response.statusCode==200){
  
   final data=json.decode(response.body)["chatId"];

   return [true,data];
  }
  else{
    
    final data= jsonDecode(response.body)["msg"];
    return[false,data] ;
  }
}  catch (e) {
print(e.toString());}
 

  }

  
  void socketservice(){
    print(socket.connected);
      socket.on("latestmessage",(message){

      MessageModel messageModel=MessageModel.fromJson(message);
   print("message last $messageModel");
    
  int index=0;

  print("index $index");   index= chats.indexWhere((element) => element.id==messageModel.chatId);


    chats.elementAt(index).messageModel=messageModel;
    chats.refresh();
  });
  }

   getCurrentUser() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if(sharedPrefs.getString("ID")!=null) {
      currentUserID.value = sharedPrefs.getString("ID")!;
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
  chats.value=data.chats;

   }
   else{
    return jsonDecode(response.body)["msg"];
   }
} catch (e) {
 print(e.toString());
}




}
}