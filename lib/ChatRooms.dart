import 'package:chat_app/ChatScreen.dart';
import 'package:chat_app/ContactsScreen.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/Services/ChatServices/chatServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatRooms extends GetView<ChatServices> {




 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  FloatingActionButton(
            onPressed: () {
              Get.to(()=> ContactsScreen());
            },
            child:const Icon(Icons.chat),
          ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff002B5B),
                Color(0xff2B4865),
              ]),
        ),
        child: 
             GetX<ChatServices>(
              
              builder: (controller) {
                return  ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.chats.length,
                    itemBuilder: ((context, index) {
                      User recieverData;
                      
                      recieverData = controller.chats[index]
                          .users
                          .firstWhere((element) => element.id != controller.currentUserID.value);
                      return InkWell(
                        onTap: (){
                  
                          Get.to(()=>ChatScreen(),arguments: [recieverData,controller.chats[index].id]);
                          
           
                        },
                        child:controller.chats[index].messageModel!=null? ListTile(
                          leading:const CircleAvatar(
                            backgroundImage: AssetImage("assets/images/avatar.png"),
                            radius: 25,
                          ),
                          title: controller.chats[index].isgroupChat
                              ? Text(controller.chats[index].chatName.toString(),style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w600))
                              : Text(recieverData.username,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.w600)),
                            subtitle: Text(controller.chats[index].messageModel!.message,style:const TextStyle(color: Colors.white),),
                        ):Container(),
                      );
                    }),
                    separatorBuilder: ((context, index) {
                      return const SizedBox(
                        height: 5,
                      );
                    }),
                  );
              },
              
             ),
            ),
    );
      

  }
}
