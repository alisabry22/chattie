import 'package:chat_app/Models/ObjectBox/user_box.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatelessWidget {
  UserBox currentuser = Get.arguments;
  List<ListTile> settings = [
    ListTile(
      leading: const Icon(
        FontAwesomeIcons.key,
        color: Colors.blueGrey,
      ),
      title: Text("Account",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 18)),
      subtitle: Text(
        "Privacy,security,change number",
        style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 14),
      ),
    ),
    ListTile(
      leading: const Icon(FontAwesomeIcons.message, color: Colors.blueGrey),
      title: Text("Chats",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 18)),
      subtitle: Text("Theme,wallpapers,chat history",
          style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 14)),
    ),
    ListTile(
      leading: const Icon(FontAwesomeIcons.bell, color: Colors.blueGrey),
      title: Text("Notification",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 18)),
      subtitle: Text("Privacy,security,change number",
          style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 14)),
    ),
    ListTile(
      leading: const Icon(FontAwesomeIcons.globe, color: Colors.blueGrey),
      title: Text("Storage and data",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 18)),
      subtitle: Text("Privacy,security,change number",
          style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 14)),
    ),
    ListTile(
      leading: const Icon(FontAwesomeIcons.language, color: Colors.blueGrey),
      title: Text("App Language",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 18)),
      subtitle: Text("Privacy,security,change number",
          style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 14)),
    ),
    ListTile(
      leading: const Icon(FontAwesomeIcons.question, color: Colors.blueGrey),
      title: Text("Help",
          style: GoogleFonts.roboto(color: Colors.white, fontSize: 18)),
      subtitle: Text("Privacy,security,change number",
          style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 14)),
    ),
  ];

  SettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0F3460),
        title: Text(
          "Settings",
          style: GoogleFonts.roboto(),
        ),
      ),
      body: Container(
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                child: InkWell(
                  onTap: (){
                       Get.to(()=>Profile(),arguments: currentuser);
                  },
                  child: Row(
                
                    children: [
                       CircleAvatar(
                        radius: 25,
                        backgroundImage:currentuser.personalphoto.isNotEmpty?MemoryImage(currentuser.personalphoto) as ImageProvider: AssetImage("assets/images/avatar.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentuser.username,
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Quote",
                              style: GoogleFonts.roboto(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const  Divider(
                height: 1.0,
                color: Color.fromARGB(255, 43, 46, 78),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: settings.length,
                  itemBuilder: (context, index) {
                    return settings[index];
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
