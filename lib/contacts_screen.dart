
import 'package:chat_app/Services/PhoneServices/phone_controller.dart';
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
        controller.isloading.value? const Center(
           child:  SizedBox(
            width: 10,
            height: 15,
              child:CircularProgressIndicator(
               strokeWidth: 3, 
                color: Colors.white,
              ) ,
            ),
         ):const SizedBox(),
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
                  onTap: () {
                   controller.isloading.value=true;
                    controller.requestContacts();
                      controller.isloading.value=false;

                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              return AnimationLimiter(
                child: ListView.separated(
                    shrinkWrap: true,
                    physics:const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: InkWell(
                            onTap: () async {},
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
                                style: GoogleFonts.roboto(
                                    color: Colors.white60),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: ((context, index) {
                      return const Divider();
                    }),
                    itemCount: controller.searchedphones.length),
              );
            },
                ),
                Text(
            "Invite to Chattie",
            style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
                ),
                ListView.separated(
              shrinkWrap: true,
              physics:const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  title: Text(
                    controller.contacts[index].displayName,
                    style: GoogleFonts.roboto(color: Colors.white),
                  ),
                  trailing: TextButton(
                    child: Text("INVITE"),
                    onPressed: () {},
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: controller.contacts.length),
              ]),
          ),
        ),
      ),
    );
  }
}
