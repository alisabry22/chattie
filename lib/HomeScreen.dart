import 'package:chat_app/AuthScreen.dart';
import 'package:chat_app/CallsPage.dart';
import 'package:chat_app/ChatRooms.dart';
import 'package:chat_app/ContactsScreen.dart';
import 'package:chat_app/StatusPage.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/ObjectBox/UserBox.dart';
import 'Services/StoryServices/StoryServices.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String currentuser="";
  Store? store;
  bool isStoreInitialized = false;
  List<UserBox>? users;
  @override
  void initState() {
        super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
      tabController.addListener(() {

  });
  getCurrentUser();

  }

  getCurrentUser()async{

    SharedPreferences sharedprefs=await SharedPreferences.getInstance();
    String? id=sharedprefs.getString("ID");
    if(id!=null){
      setState(() {
        currentuser=id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: AppBar(
        backgroundColor:const Color(0xff002B5B),
        actions: [
          IconButton(onPressed: () {}, icon:const Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (context) {
              return  [
               const PopupMenuItem(
                  value: 1,
                  child: Text("New Group"),
                ),
              const  PopupMenuItem(
                 
                  value: 2,
                   child: Text("Settings"),
                ),
                PopupMenuItem(
                  
                  value: 3,
                  child:  Text("Logout"),
                 
                ),
              ];
            },
            onSelected: ((value) async {
              if (value == 3) {
                SharedPreferences sharedprefs =
                    await SharedPreferences.getInstance();
                sharedprefs.remove("token");
                sharedprefs.remove("ID");
                Get.offAll(() => AuthScreen());
                  Query query=objectBox.userBox.query(UserBox_.userID.equals(currentuser.toString())).build();
                    UserBox userBox=query.findFirst();
                    objectBox.userBox.remove(userBox.id);
                    objectBox.userBox.removeAll();
              }
            }),
          ),
        ],
        title:const Text("Home Screen"),
        bottom: TabBar(

          onTap: (index){
         
          },
          controller: tabController,
          tabs: const [
            Tab(
              text: "Chats",
            ),
            Tab(
              text: "Status",
            ),
            Tab(
              text: "Calls",
            )
          ],
        ),
      ),
      body: TabBarView(
          controller: tabController,
        children: [
          ChatRooms(),
          StatusPage(),
          CallsPage(),
        ],
      
      ),
    );
  }


}
