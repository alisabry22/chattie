import 'package:chat_app/ChatScreen.dart';
import 'package:chat_app/Models/ChatModel.dart';
import 'package:chat_app/Models/MessageModel.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/Services/ChatServices/chatServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'main.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key}) : super(key: key);

  @override
  State<ChatRooms> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ChatRooms> {
  List<ChatModel> chats = [];
  String? currentUserID;
  @override
  void initState() {
    super.initState();
    socket.connect();
   socket.onConnect((data){
  socket.on("latestmessage",(message){
    print(message as Map<String,dynamic>);
    MessageModel messageModel=MessageModel.fromJson(message as Map<String,dynamic>);
  int index=0;
   index= chats.indexWhere((element) => element.id==messageModel.id);
   setState(() {
     chats[index].messageModel=messageModel;
   });
  });
   });

    getAllChats();
    getCurrentUser();
  }

  Future getAllChats() async {
    List<ChatModel> retrieveChats = [];
    retrieveChats = await ChatServices().getAllChats();
    if (retrieveChats.isNotEmpty) {
      setState(() {
        chats = retrieveChats;
       
      });
    }

  }

  Future getCurrentUser() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    currentUserID = sharedPrefs.getString("ID");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff002B5B),
              Color(0xff2B4865),
            ]),
      ),
      child: chats.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              itemCount: chats.length,
              itemBuilder: ((context, index) {
                User recieverData;
                
                recieverData = chats[index]
                    .users
                    .firstWhere((element) => element.id != currentUserID);
                return InkWell(
                  onTap: (){
                    Get.to(()=>ChatScreen(),arguments: [recieverData,chats[index].id]);
                  },
                  child:chats[index].messageModel!=null? ListTile(
                    leading:const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 25,
                    ),
                    title: chats[index].isgroupChat
                        ? Text(chats[index].chatName.toString(),style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w600))
                        : Text(recieverData.username,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w600)),
                      subtitle: Text(chats[index].messageModel!.message,style:const TextStyle(color: Colors.white),),
                  ):Container(),
                );
              }),
              separatorBuilder: ((context, index) {
                return const SizedBox(
                  height: 5,
                );
              }),
            )
          : Container(),
    );
  }
}
