import 'package:chat_app/AuthScreen.dart';
import 'package:chat_app/CallsPage.dart';
import 'package:chat_app/ChatRooms.dart';
import 'package:chat_app/ContactsScreen.dart';
import 'package:chat_app/StatusPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/ObjectBox/UserBox.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  Store? store;
  bool isStoreInitialized = false;
  List<UserBox>? users;
  int tabindex=0;
  @override
  void initState() {
    tabindex=0;
        super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
      tabController.addListener(() {
   
    setState(() {
      tabindex=tabController.index;
    });
  });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButtons(),
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
              if (value == 3) {
                SharedPreferences sharedprefs =
                    await SharedPreferences.getInstance();
                sharedprefs.remove("token");
                sharedprefs.remove("ID");
                Get.offAll(() => AuthScreen());
              }
            }),
          ),
        ],
        title:const Text("Home Screen"),
        bottom: TabBar(

          onTap: (index){
            setState(() {
              tabindex=index;
            });
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
        children: const[
          ChatRooms(),
          StatusPage(),
          CallsPage(),
        ],
      
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return tabindex == 0
        ? FloatingActionButton(
            onPressed: () {
              Get.to(()=>const ContactsScreen());
            },
            child:const Icon(Icons.chat),
          )
        : tabindex == 1
            ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "pen",
                    onPressed: () {},
                    child:const Icon(FontAwesomeIcons.pen),
                  ),
                 const SizedBox(height: 5,),
                  FloatingActionButton(
                    heroTag: "camera",
                    onPressed: () {},
                    child:const Icon(Icons.camera_alt),
                  ),
              ],
            )
            : FloatingActionButton(onPressed: () {},child:const Icon(FontAwesomeIcons.phone),);
  }
}
