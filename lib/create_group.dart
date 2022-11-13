

import 'package:chat_app/Services/PhoneServices/phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroup extends GetView<PhoneController> {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("New group ",style: GoogleFonts.roboto(color:Colors.white),),
          const  SizedBox(height: 5,),
            Text("Add participants ",style: GoogleFonts.roboto(color:Colors.white),),
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.search)),
        ],
      ),
    );
  }
}