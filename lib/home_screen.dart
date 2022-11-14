import 'package:chat_app/Models/ObjectBox/user_box.dart';
import 'package:chat_app/calls_page.dart';
import 'package:chat_app/auth_screen.dart';
import 'package:chat_app/chat_rooms.dart';
import 'package:chat_app/create_group.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/objectbox.g.dart';
import 'package:chat_app/settings_screen.dart';
import 'package:chat_app/status_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
              return const [
                PopupMenuItem(
                  value: 1,
                  child: Text("New Group"),
                 
                ),
                PopupMenuItem(
                 
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
              if(value==1){
                Get.to(()=>const CreateGroup());
              }
              if (value == 3) {
                SharedPreferences sharedprefs =
                    await SharedPreferences.getInstance();
                sharedprefs.remove("token");
                sharedprefs.remove("ID");
                Get.offAll(() => AuthScreen());
                 
                   
                    objectBox.userBox.removeAll();
              }else if (value==2){
                    Query query=objectBox.userBox.query(UserBox_.userID.equals(currentuser.toString())).build();
                    UserBox userBox=query.findFirst();
                Get.to(()=>  SettingScreen(),arguments:userBox );

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
        const  ChatRooms(),
          StatusPage(),
         const CallsPage(),
        ],
      
      ),
    );
  }


}
