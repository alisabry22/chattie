import 'package:chat_app/Models/ObjectBox/user_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

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
                        :const AssetImage("assets/images/avatar.png"),
                  ),
                  Positioned(
                      right: 3,
                      bottom: 0,
                      child: InkWell(
                        onTap: () async {
                          photofile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
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
                              "Quote",
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
