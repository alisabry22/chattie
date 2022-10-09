import 'package:animations/animations.dart';
import 'package:chat_app/LoginScreen.dart';
import 'package:chat_app/SignupScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoggin = true;
 final loginkey=GlobalKey<FormState>();
  final Registerkey=GlobalKey<FormState>();
  late List<Contact> contacts;
  @override
  void initState() {
   
    super.initState();
    requestContacts();
  }
Future requestContacts ()async{
await FlutterContacts.requestPermission();

}

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
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isLoggin = true;
                  });
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
                  setState(() {
                    isLoggin = false;
                  });
                },
                child: const Text(
                  "Signup",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
            PageTransitionSwitcher(
                duration: Duration(milliseconds: 500),
                reverse: !isLoggin,
                transitionBuilder: (child, animation, secondaryAnimation) {
                  return SharedAxisTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                child: isLoggin ? const LoginScreen() : const SignUpScreen()),
          ]),
        ),
      ),
    );
  }
}

