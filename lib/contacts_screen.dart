import 'package:chat_app/Models/user.dart';
import 'package:chat_app/Services/AuthServices/auth_services.dart';
import 'package:chat_app/Services/ChatServices/chat_services.dart';
import 'package:chat_app/Services/PhoneServices/phone_controller.dart';
import 'package:chat_app/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsScreen extends GetView<PhoneController> {
  bool phonefound = false;

  ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      hintStyle: TextStyle(color: Colors.white),
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
                        "${controller.contacts.length} contacts",
                        style: GoogleFonts.openSans(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.issearching.value = !controller.issearching.value;
              },
              icon: const Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text("Refresh")),
              ];
            },
          ),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),
                    child: Icon(FontAwesomeIcons.userGroup),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                      child: Text(
                    "New Group",
                    style:
                        GoogleFonts.roboto(fontSize: 18, color: Colors.white),
                  ))
                ],
              ),
            ),
            Text("Contacts Using App",style: GoogleFonts.roboto(fontSize: 18,color:Colors.blueGrey),),
            GetX<PhoneController>(
              builder: (controller) {
                return AnimationLimiter(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (controller.contacts[index].phones.isNotEmpty) {
                          var phonetest = controller
                              .contacts[index].phones.first.number
                              .replaceAll(" ", "");
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: InkWell(
                                onTap: () async {
                                  int phoneindex = 0;
                                  for (int i = 0;
                                      i < controller.users.length;
                                      i++) {
                                    if (controller.users[i].phone ==
                                        phonetest) {
                                      phonefound = true;
                                      phoneindex = i;
                                      break;
                                    }
                                    phonefound = false;
                                  }

                                  if (phonefound) {
                                    final data = await AuthServices()
                                        .getUserInfo(
                                            controller.users[phoneindex].phone);
                                    if (data is User) {
                                      var chatId;
                                      chatId = await ChatServices()
                                          .createChat(data.id);
                                      if (chatId[0] == true) {
                                        User recieverData = data;

                                        Get.to(() => const ChatScreen(),
                                            arguments: [
                                              recieverData,
                                              chatId[1]
                                            ]);
                                      }
                                    } else {
                                      Get.snackbar("Error ", data,
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: const Duration(seconds: 2));
                                    }
                                  } else {
                                    Get.snackbar("Not Using App",
                                        "This user isn't using our app",
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: const Duration(seconds: 2));
                                  }
                                },
                                child: ListTile(
                                  leading: const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.png")),
                                  title: Text(
                                    controller.contacts[index].displayName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    controller.contacts[index].phones
                                        .elementAt(0)
                                        .number
                                        .replaceAll(" ", ""),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                      separatorBuilder: ((context, index) {
                        return const Divider();
                      }),
                      itemCount: controller.contacts.length),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
