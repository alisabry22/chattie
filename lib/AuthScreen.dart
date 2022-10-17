import 'package:animations/animations.dart';
import 'package:chat_app/LoginScreen.dart';
import 'package:chat_app/SignupScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

import 'Services/AuthServices/AuthServices.dart';

class AuthScreen extends GetView<AuthServices>{


  bool isLoggin = true;
 final loginkey=GlobalKey<FormState>();
  final Registerkey=GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    
      appBar: AppBar(title: const Text("Login Screen"),backgroundColor:const Color(0xff16213E) ,elevation: 0,),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        decoration:const BoxDecoration(
         
          gradient: LinearGradient(
              begin:Alignment.topCenter ,
              end: Alignment.bottomCenter,
             colors:  [
            Color(0xff0F3460),
            Color(0xff16213E),
          ]),
        ),
        child: GetX<AuthServices>(
          builder: (controller) {
            return   SingleChildScrollView(
            child: Column(
              
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.1,),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                  onPressed: () {
                    controller.islogin.value=true;
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () {
                   controller.islogin.value=false;
                  },
                  child: const Text(
                    "Signup",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
              PageTransitionSwitcher(
                  duration: Duration(milliseconds: 500),
                  reverse: !controller.islogin.value,
                  transitionBuilder: (child, animation, secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: controller.islogin.value ? const LoginScreen() : const SignUpScreen()),
            ]),
          );
          },
         
        ),
      ),
    );
  }
}

