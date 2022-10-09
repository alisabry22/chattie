    import 'package:chat_app/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Services/AuthServices/AuthServices.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


  final loginkey=GlobalKey<FormState>();
    final emailController = TextEditingController();
  final passwordController = TextEditingController();
  return ClipRRect(
    borderRadius:const BorderRadius.all(Radius.circular(25)),
    child: Container(
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.9,
        decoration:const BoxDecoration(
           color:  Color(0xff002B5B),
          
          gradient: LinearGradient(
               
               colors: [
              Color(0xff002B5B),
              Color(0xff2B4865),
            ]),
        ),
        
                  
        child: Column(
          children: [
         
              
               Center(
                child: Container(
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    
                        key: loginkey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: TextFormField(
                                style: const TextStyle(color: Colors.white),
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                           const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: TextFormField(
                                style:const TextStyle(color: Colors.white),
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        const    SizedBox(height: 90,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),

                                gradient:const LinearGradient(colors: [
                                  Color(0xff3120E0),
                                 Color(0xff3B9AE1),
                                ]),
                              ),
                              child: ElevatedButton(
                                style:ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  disabledBackgroundColor: Colors.transparent,
                                   disabledForegroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  
                                ),
                                  onPressed: ()async{
                                    if (loginkey.currentState!.validate()) {
                                      final response =await  AuthServices().loginFunction(
                                          emailController.text.trim(),
                                          passwordController.text.trim());
                                      if (response==true) {
                                       
                                        Get.offAll(() => const HomeScreen());
                                      } else {
                                        Get.snackbar(
                                            "Error message", response.toString(),
                                            duration: const Duration(seconds: 3),
                                            snackPosition: SnackPosition.BOTTOM);
                                      }
                                    }
                                  },
                                  child: const Text("Sign in")),
                            ),
                          ],
                        )),
                ),
                
              ),
           
          ],
        ),
      ),
  );
  }
}