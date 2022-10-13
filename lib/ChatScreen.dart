
import 'dart:convert';

import 'package:chat_app/Models/MessageModel.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/Services/MessageServices/MessageServices.dart';
import 'package:chat_app/main.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scrollController = ScrollController( );
  List<MessageModel> messages = [];
  var data = Get.arguments ;
  User? receiverData;
  String? currentUserId;
   String? currentuser;

 
  @override
  void initState() {
    super.initState();
  receiverData=data[0] as User;
    getuser();
    socket.connect();
    fetchAllMessages();
    connectToSocket();
  }

  

  void appendMessage(data ) {
    Map<String,dynamic>message=data as Map<String,dynamic>;
 MessageModel messageModel=MessageModel.fromJson(message );

    if(mounted){
setState(() {
        messages.add(messageModel);
           scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration:const Duration(milliseconds: 1),
                            curve: Curves.easeOut);
      });
       
    }
          

      
  
  }

  Future getuser() async {
    SharedPreferences sharedprefs = await SharedPreferences.getInstance();

  
 
    setState(() {
           currentuser = sharedprefs.getString("ID");
    });
  }

  Future fetchAllMessages() async {
    List<MessageModel> retieveMessages = [];
    retieveMessages = await MessageServices().getAllChatMessages(data[1]);
    if (retieveMessages.isNotEmpty) {
      setState(() {
        messages = retieveMessages;
        
      });
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
           scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration:const Duration(milliseconds: 1),
                            curve: Curves.easeOut);
      });
       
    }
  }
  void connectToSocket() async{
   
  SharedPreferences sharedPrefs=await SharedPreferences.getInstance();
    currentUserId=sharedPrefs.getString("ID");
   


  socket.emit("JoinChat",data[1]);
   socket.on("JoinChat",(returneddata){
    
    print(returneddata);
   });
    socket.on("message", (message) {
        appendMessage(message);

    
  });
  }

  @override
  Widget build(BuildContext context) {
   
    final size = MediaQuery.of(context).size;
    final messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: Text(receiverData!.username),
          backgroundColor:const Color(0xff002B5B)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: messages.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
              
                    controller: scrollController,
                    itemCount: messages.length+1,
                    itemBuilder: (context, index) {
                      if(index==messages.length){
                        return Container(height: 50,);
                      }
                      bool issender = false;
                      if (messages[index].senderData.id == currentuser) {
                        issender = true;
                      }
                      return BubbleSpecialThree(
                        text: messages[index].message,
                        tail: false,
                        textStyle:const TextStyle(fontSize: 16),
                        color: issender ?const Color(0xFF1B97F3) :const Color(0xFFE8E8EE),
                        isSender: issender,
                      );
                    })
                : Container(),
          ),
          Row(children: [
            Container(
              height: 50,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey.shade300,
              ),
              child: TextFormField(
                
                controller: messageController,
                decoration:const InputDecoration(
                  hintText: "Message",
                  prefixIcon: Icon(Icons.emoji_emotions),
                ),
              ),
            ),
           const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                      onPressed: () {
                    
                 
                  
                        socket.emit("sendMessage", {
                          "content": messageController.text.trim(),
                          "sender": currentuser,
                          "chatId":data[1],
                        
                        });
                                 
                        messageController.text = "";
                        
                          
                      },
                      icon:const Icon(Icons.send_rounded))),
            ),
          ]),
        ],
      ),
    );
  }
}
