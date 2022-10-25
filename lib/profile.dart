import 'package:chat_app/Models/ObjectBox/user_box.dart';
import 'package:chat_app/Services/ProfileServices/profile_controller.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  late XFile photo;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserBox userBox = Get.arguments;
  XFile? photofile;
  Uint8List? profilephoto;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.roboto(),
        ),
        backgroundColor: const Color(0xff0F3460),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userBox.personalphoto.isNotEmpty
                        ? MemoryImage(userBox.personalphoto) as ImageProvider
                        : const AssetImage("assets/images/avatar.png"),
                  ),
                  Positioned(
                      right: 3,
                      bottom: 0,
                      child: InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Profile Photo"),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                alignment: Alignment.bottomCenter,
                                insetPadding: EdgeInsets.zero,
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  )),
                                              child: const Icon(
                                                  FontAwesomeIcons.camera)),
                                          Text(
                                            "Camera",
                                            style: GoogleFonts.roboto(
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          String photourl;
                                          var returnedvalue;
                                          photofile = await ProfileController()
                                              .pickImage();
                                          photourl = await ProfileController()
                                              .uploadStoryToCloud(
                                                  photofile!, "profilephotos");
                                          returnedvalue = ProfileController()
                                              .updateProfilephoto(photourl);
                                          if (returnedvalue == true) {
                                            Get.snackbar("Done updating",
                                                "changed profile photo successfully",
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                duration:
                                                    Duration(milliseconds: 3));
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: const Icon(
                                                    FontAwesomeIcons
                                                        .photoFilm)),
                                            Text(
                                              "Gallery",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromARGB(255, 2, 2, 87),
                            child: Icon(
                              FontAwesomeIcons.camera,
                              color: Colors.white,
                            )),
                      )),
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: "Enter your name",
                    content: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: userBox.username,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("CANCEL")),
                      TextButton(onPressed: () {}, child: const Text("SAVE")),
                    ],
                  );
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.person,
                              color: Colors.blueGrey.withOpacity(0.3),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name",
                                    style: GoogleFonts.roboto(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    userBox.username,
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.pen,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ]),
              ),
              const Divider(
                color: Colors.blueGrey,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.quoteLeft,
                        color: Colors.blueGrey.withOpacity(0.3),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About",
                              style: GoogleFonts.roboto(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              //replace with quote
                              objectBox.userBox.getAll().first.quote,
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  FontAwesomeIcons.pen,
                  color: Colors.white.withOpacity(0.3),
                ),
              ]),
              const Divider(
                color: Colors.blueGrey,
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.phone,
                    color: Colors.blueGrey.withOpacity(0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone",
                          style: GoogleFonts.roboto(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          //replace with quote
                          userBox.phone,
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
