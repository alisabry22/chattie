import 'package:animations/animations.dart';
import 'package:chat_app/Services/AuthServices/auth_services.dart';
import 'package:chat_app/login_screen.dart';
import 'package:chat_app/signup_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthScreen extends GetView<AuthServices>{


  bool isLoggin = true;
 final loginkey=GlobalKey<FormState>();
  final Registerkey=GlobalKey<FormState>();

  AuthScreen({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    backgroundColor: Colors.transparent,
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
                  duration:const Duration(milliseconds: 500),
                  reverse: !controller.islogin.value,
                  transitionBuilder: (child, animation, secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      
                      fillColor: Colors.transparent,
                      child: child,
                    );
                  },
                  child: controller.islogin.value?LoginScreen():const SignUpScreen()),
            ]),
          );
          },
         
        ),
      ),
    );
  }
}

