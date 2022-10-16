

import 'package:chat_app/Services/MessageServices/MessageServices.dart';
import 'package:chat_app/main.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends GetView<MessageServices>{

 
  @override
  Widget build(BuildContext context) {
   
    final size = MediaQuery.of(context).size;
    final messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          title: Text(controller.user.value.username),
          backgroundColor:const Color(0xff002B5B)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: 
              GetX<MessageServices>(
                builder: (controller) {

                  return  ListView.builder(
                      shrinkWrap: true,
                
                      itemCount:controller.messages.length+1,
                      itemBuilder: (context, index) {
                        if(index==controller.messages.length){
                          return Container(height: 50,);
                        }
                        bool issender = false;
                        if (controller.messages[index].senderData.id == controller.currentuser.value) {
                          issender = true;
                        }
                        return BubbleSpecialThree(
                          text:controller. messages[index].message,
                          tail: false,
                          textStyle:const TextStyle(fontSize: 16),
                          color: issender ?const Color(0xFF1B97F3) :const Color(0xFFE8E8EE),
                          isSender: issender,
                        );
                      });
                },
              
              )
              
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
                          "sender": controller.currentuser.value,
                          "chatId":controller.chatId.value,
                        
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
