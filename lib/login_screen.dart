import 'package:chat_app/Services/AuthServices/auth_services.dart';
import 'package:chat_app/Services/AuthServices/login_response.dart';
import 'package:chat_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


    
      @override
     State<LoginScreen> createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{

  final _loginkey=GlobalKey<FormState>();
    final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {

  return Padding(
    padding: const EdgeInsets.only(top: 30),
    child: Container(
  
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.9,
        
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(20),
          gradient:const LinearGradient(
               
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      
                          key: _loginkey,
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
                                      if (_loginkey.currentState!.validate()) {
                                        final response =await  AuthServices().loginFunction(
                                            emailController.text.trim(),
                                           passwordController.text.trim());
                                        if (response[0]==true && response[1] is LoginResponse) {
                                          
                                          Get.offAll(() => const HomeScreen());
                                        } else {
                                          Get.snackbar(
                                              "Error message", response[1].toString(),
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
                
              ),
           
          ],
        ),
      ),
  );
  }
     }



  
