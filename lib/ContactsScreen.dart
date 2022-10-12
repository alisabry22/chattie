import 'package:chat_app/ChatScreen.dart';
import 'package:chat_app/Models/ObjectBox/UserBox.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/Services/ChatServices/chatServices.dart';
import 'package:chat_app/Services/PhoneServices/phoneController.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];
  List<Contact> filterResult=[];

  var responsePhoneController;
  bool issearching = false;
  bool phonefound = false;
  List<String>phones=[];
  List<User> users = [];
  @override
  void initState() {

    super.initState();
    requestContacts();
    
  }




  requestContacts() async {
       SharedPreferences sharedprefs=await SharedPreferences.getInstance();
    if (await FlutterContacts.requestPermission()) {
      List<Contact> democontact = await FlutterContacts.getContacts(withProperties: true);

if(democontact.isNotEmpty){
 democontact.forEach((element) {
element.phones.forEach((phone) {
  phones.add(phone.number.replaceAll(" ", "").toString());
});
 });
 
 String? id = sharedprefs.getString("ID");

Query<UserBox> query=objectBox.userBox.query(UserBox_.userID.equals(id!)).build();
UserBox? userBox=query.findFirst();

  userBox!.phones=phones.toSet().toList();
  objectBox.userBox.put(userBox);
setState(() {
        contacts = democontact;
     
      });

  

      
}
      
      responsePhoneController = await phoneController().getPhonesList(contacts);
      if (responsePhoneController is List) {
        setState(() {
          users = responsePhoneController;
         
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: issearching
            ? BackButton(
                onPressed: () {
                  setState(() {
                    issearching = !issearching;
                  });
                },
              )
            : BackButton(
                onPressed: () {
                  Get.back();
                },
              ),
        backgroundColor:const Color(0xff0F3460),
        title: issearching
            ? TextField(
                onChanged: ((query) => runfilter( query)),
                
                decoration:const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.white),
                ),
              )
            : const Text("Contacts"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  issearching = !issearching;
                });
              },
              icon:const Icon(Icons.search)),
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
        child:  contacts.isNotEmpty?
               AnimationLimiter(
                
                 child: ListView.separated(
                             itemBuilder: (context, index) {
                         
                  if (contacts[index].phones.isNotEmpty) {
                    var phonetest =
                        contacts[index].phones.first.number.replaceAll(" ", "");
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: InkWell(
                          onTap: () async {
                                        
                            int phoneindex = 0;
                            for (int i = 0; i < users.length; i++) {
                              if (users[i].phone == phonetest) {
                                phonefound = true;
                                phoneindex = i;
                                break;
                              }
                              phonefound = false;
                            }
                          
                         
                        
                            if (phonefound) {
                              
                              final data = await AuthServices()
                                  .getUserInfo(users[phoneindex].phone);
                              if (data is User) {
                                var chatId;
                              chatId=  await ChatServices().createChat(data.id);
                              print("chatId $chatId");
                              if(chatId[0]==true){
                                 User recieverData=data ;
                              
                                Get.to(() =>const ChatScreen(), arguments: [recieverData,chatId[1]]);
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
                              contacts[index].displayName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              contacts[index]
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
                             itemCount: contacts.length),
               ):Container()
    
      ),
    );
  }
  void runfilter(String value)async{
    if(value.isNotEmpty){
      
      filterResult=contacts.where((element) => element.displayName.toLowerCase().contains(value.toLowerCase())).toList();
      
      setState(() {
        contacts=filterResult;
      });
    
    }
    else{
      final dummylist=await FlutterContacts.getContacts(withProperties: true);
      setState(()  {
        contacts=dummylist;
      });
    }
}
}