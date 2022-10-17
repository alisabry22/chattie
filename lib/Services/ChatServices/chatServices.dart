import 'dart:convert';

import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/MessageModel.dart';
import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/Services/ChatServices/chatresponse.dart';
import 'package:chat_app/socketServices/socketservices.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../Models/ChatModel.dart';

class ChatServices extends GetxController{

 RxList<ChatModel>chats=<ChatModel>[].obs;
  RxString currentUserID="".obs;
 @override
  void onInit()async {
    Get.put<SocketServices>(SocketServices());
    super.onInit();
 SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if(sharedPrefs.getString("ID")!=null) {
      currentUserID.value = sharedPrefs.getString("ID")!;
    }
    getAllChats();
    socketservice();
   
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
  Socket socket=  Get.find<SocketServices>().socket;
      socket.on("latestmessage",(message){

      MessageModel messageModel=MessageModel.fromJson(message);
    
  int index=0;

 
  index= chats.indexWhere((element) => element.id==messageModel.chatId);


    chats.elementAt(index).messageModel=messageModel;
    chats.refresh();


  });

  socket.on("createdchat", (data) {
    ChatModel chatModel=ChatModel.fromJson(data as Map<String,dynamic>);
 
    chats.add(chatModel);
  });

  socket.on("deletedchat", (data) {
    
  
    if(chats.isNotEmpty){
      int index =chats.indexWhere((element) =>element.id==data.toString());
      chats.removeAt(index);
    }
 
  });
  }




  Future getAllChats()async{
    print("get all chats called");

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
  update();

   }
   else{
    return jsonDecode(response.body)["msg"];
   }
} catch (e) {
 print(e.toString());
}




}
}