import 'package:chat_app/ChatScreen.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/Services/ChatServices/chatServices.dart';
import 'package:chat_app/Services/PhoneServices/phoneController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class ContactsScreen extends GetView<phoneController> {
 

  bool phonefound = false;
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GetX<phoneController>(
          builder: (controller) {
            return controller.issearching.value?BackButton(
                  onPressed: () {
                 controller.issearching.value=!controller.issearching.value;
                  },
                ):BackButton(
                  onPressed: () {
                    Get.back();
                  },
                );
          },
 
             
        ),
        backgroundColor:const Color(0xff0F3460),
        title: GetX<phoneController>(
          builder: (controller){
            return controller.issearching.value?TextField(
                  onChanged: ((query) => controller.runfilter( query)),
                  
                  decoration:const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ):const Text("Contacts");
          },
    
              
        ),
        actions: [
     
             IconButton(
                onPressed: () {
                 controller.issearching.value=!controller.issearching.value;
                },
                icon:const Icon(Icons.search))
        
          
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff0F3460),
                Color(0xff16213E),
              ]),
        ),
        child:  
               GetX<phoneController>(
                builder: (controller) {
                  return  AnimationLimiter(
                  
                   child: ListView.separated(
                               itemBuilder: (context, index) {
                           
                    if (controller.contacts[index].phones.isNotEmpty) {
                      var phonetest =
                          controller.contacts[index].phones.first.number.replaceAll(" ", "");
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: InkWell(
                            onTap: () async {
                                          
                              int phoneindex = 0;
                              for (int i = 0; i < controller.users.length; i++) {
                                if (controller.users[i].phone == phonetest) {
                                  phonefound = true;
                                  phoneindex = i;
                                  break;
                                }
                                phonefound = false;
                              }
                            
                           
                          
                              if (phonefound) {
                                
                                final data = await AuthServices()
                                    .getUserInfo(controller.users[phoneindex].phone);
                                if (data is User) {
                                  var chatId;
                                chatId=  await ChatServices().createChat(data.id);
                                if(chatId[0]==true){
                                   User recieverData=data ;
                                
                                  Get.to(() => ChatScreen(), arguments: [recieverData,chatId[1]]);
                                }
                                
                                  
                          
                                } else {
                                  Get.snackbar("Error ", data,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2));
                                }
                              } else {
                                Get.snackbar(
                                    "Not Using App", "This user isn't using our app",
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2));
                              }
                            },
                            child: ListTile(
                              leading:const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/avatar.png")),
                              title: Text(
                                controller.contacts[index].displayName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                 controller.contacts[index]
                                    .phones
                                    .elementAt(0)
                                    .number
                                    .replaceAll(" ", ""),
                                style:const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return  Container();
                    }
                               },
                               separatorBuilder: ((context, index) {
                    return const Divider();
                               }),
                               itemCount:  controller.contacts.length),
                  );
                
                },
               ),
               
              
    
      ),
    );
  }

}