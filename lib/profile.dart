import 'package:chat_app/Models/ObjectBox/user_box.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  final UserBox userBox = Get.arguments;

  Profile({super.key});
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
                child: Stack(children:const [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  Positioned(
                      right: 3,
                      bottom: 0,
                      child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Color.fromARGB(255, 2, 2, 87),
                          child: Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                          ))),
                ]),
              ),
             const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
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
                                  color: Colors.blueGrey, fontWeight: FontWeight.w500),
                            ),
                             Text(
                              userBox.username,
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontWeight: FontWeight.w500,fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                ),
                 Icon(FontAwesomeIcons.pen,color: Colors.white.withOpacity(0.3),),
                ]
                 
              ),
            const  Divider(color: Colors.blueGrey,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
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
                                  color: Colors.blueGrey, fontWeight: FontWeight.w500),
                            ),
                             Text(
                              //replace with quote
                              "Quote",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontWeight: FontWeight.w500,fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                ),
                 Icon(FontAwesomeIcons.pen,color: Colors.white.withOpacity(0.3),),
                ]
                 
              ),
             const Divider(color: Colors.blueGrey,),
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
                                  color: Colors.blueGrey, fontWeight: FontWeight.w500),
                            ),
                             Text(
                              //replace with quote
                              userBox.phone,
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontWeight: FontWeight.w500,fontSize: 16),
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
