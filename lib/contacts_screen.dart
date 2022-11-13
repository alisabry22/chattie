import 'dart:developer';

import 'package:chat_app/Services/ChatServices/chat_services.dart';
import 'package:chat_app/Services/PhoneServices/phone_controller.dart';
import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsScreen extends GetView<PhoneController> {
  bool phonefound = false;
  ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff002B5B),
      appBar: AppBar(
        leading: GetX<PhoneController>(
          builder: (controller) {
            return controller.issearching.value
                ? BackButton(
                    onPressed: () {
                      controller.issearching.value =
                          !controller.issearching.value;
                    },
                  )
                : BackButton(
                    onPressed: () {
                      Get.back();
                    },
                  );
          },
        ),
        backgroundColor: const Color(0xff0F3460),
        title: GetX<PhoneController>(
          builder: (controller) {
            return controller.issearching.value
                ? TextField(
                    onChanged: ((query) => controller.runfilter(query)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contacts",
                        style: GoogleFonts.roboto(),
                      ),
                      Text(
                        "${controller.searchedphones.length} contacts",
                        style: GoogleFonts.openSans(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
          },
        ),
        actions: [
          GetX<PhoneController>(
            builder: (controller) {
             

              return controller.isloading.value
                  ? const Center(
                      child: SizedBox(
                        width: 10,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
          IconButton(
              onPressed: () {
             
                controller.issearching.value = !controller.issearching.value;
              },
              icon: const Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("Refresh"),
                  onTap: () async{
                
                    controller.isloading.value = true;
                 await   controller.requestContacts();
                     
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 2, 54, 119),
                  ),
                  child: const Icon(
                    FontAwesomeIcons.userGroup,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Create New Group",
                  style: GoogleFonts.roboto(color: Colors.white),
                ),
              ),
              Text(
                "Contacts on Chattie",
                style: GoogleFonts.roboto(fontSize: 18, color: Colors.white),
              ),
              GetX<PhoneController>(
                builder: (controller) {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            var data;
                            data = await ChatServices().createChat(
                                controller.searchedphones[index].id);
                            if (data[0] == true) {
                              Get.to(() => const ChatScreen(), arguments: [
                                controller.searchedphones[index],
                                data[1]
                              ]);
                            }
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(controller
                                    .searchedphones[index].profilephoto)),
                            title: Text(
                              controller.searchedphones[index].username,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              controller.searchedphones[index].quote,
                              style: GoogleFonts.roboto(color: Colors.white60),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: ((context, index) {
                        return const Divider();
                      }),
                      itemCount: controller.searchedphones.length);
                },
              ),
              Text(
                "Invite to Chattie",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
              ),
              GetX<PhoneController>(
                builder: (controller) {
                  if (controller.contactsToShow.isNotEmpty) {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                      
                          return ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  AssetImage("assets/images/avatar.png"),
                            ),
                            title:  Text(
                                    controller.contactsToShow[index].displayName.toString(),
                                       
                                    style:
                                        GoogleFonts.roboto(color: Colors.white)),
                              
                            trailing: TextButton(
                              child: Text(
                                "INVITE",
                                style: GoogleFonts.roboto(),
                              ),
                              onPressed: () {},
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: controller.contactsToShow.length);
                  } else {
                    return Center(
                      child: Text(
                        "Add More People to Chat ",
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 16),
                      ),
                    );
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
