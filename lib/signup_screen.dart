import 'dart:io';

import 'package:chat_app/Services/AuthServices/auth_services.dart';
import 'package:chat_app/Services/AuthServices/login_response.dart';
import 'package:chat_app/home_screen.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'Models/ObjectBox/user_box.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});


@override
State<SignUpScreen> createState()=>_SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen>{

  String countryCode = "+20";
         final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  bool obscurevalue=false;
   Uint8List? personalphoto;
 late XFile file;
 late UserBox userBox;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(colors: [
            Color(0xff002B5B),
            Color(0xff2B4865),
          ]),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -30,
              child: Stack(children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:personalphoto!=null?MemoryImage(personalphoto!)as ImageProvider:const AssetImage("assets/images/avatar.png"),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: ()async{
                    file = await  AuthServices().pickImage();
      
                            if(file!=null){
                              Uint8List photo =await File(file.path).readAsBytes();
                                if(photo!=null){
                          setState(() {
                            personalphoto=photo;
                          });
                        }
                            }
                            
                  
                      
      
                      },
                      child:const Icon(FontAwesomeIcons.circlePlus))),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child:  Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          controller: usernameController,
                          decoration: const InputDecoration(
                            hintText: "Username",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                           child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            controller:passwordController,
                            keyboardType: TextInputType.number,
                            obscureText: obscurevalue,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      obscurevalue=!obscurevalue;
                                    });
                                  
                                  },
                                  child: obscurevalue
                                      ? const Icon(Icons.lock_open)
                                      : const Icon(Icons.lock)),
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ),
                        
                           
                      
                    
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller:emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            fillColor: Colors.black,
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      IntlPhoneField(
                        initialCountryCode: "EG",
                        controller:phoneController,
                        autovalidateMode: AutovalidateMode.disabled,
                        disableLengthCheck: true,
                        dropdownTextStyle: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        pickerDialogStyle:
                            PickerDialogStyle(backgroundColor: Colors.white),
                        style: const TextStyle(color: Colors.white),
                        onCountryChanged: (str) {
                          countryCode = str.dialCode.toString();
                        },
                      ),
                      const Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(colors: [
                                 Color.fromARGB(255, 10, 5, 61),
                                 Color.fromARGB(255, 9, 62, 103),
                          ]),
                        ),
                        child: TextButton(
                           
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                String photourl;
                              photourl=await AuthServices().uploadStoryToCloud(file, "profilephotos");
                                final respond =
                                    await AuthServices().signUpFunction(
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
                                 emailController.text.trim(),
                                  phoneController.text.trim(),
                                  countryCode,
                                  photourl,
                                );
                              
                                if (respond[0] == true &&
                                    respond[1] is LoginResponse) {
                                  LoginResponse userresponse = respond[1];

                                  objectBox.userBox.removeAll();
                                  //store user data Locally
                                  UserBox userBox = UserBox(
                                    userID: userresponse.user.id,
                                    username:usernameController.text,
                                    email:emailController.text,
                                    phone: phoneController.text.trim(),
                                    countrycode: countryCode,
                                    phones: [],
                                    personalphoto: personalphoto!,
                                    quote: "Hello There Iam Using chattie"
                                  );
                                  objectBox.userBox.put(userBox);
                                  objectBox.userBox.getAll().forEach((element) {
                                    print(element.id);
                                  });
                              
                                  Get.offAll(() => const HomeScreen());
                                } else {
                                  Get.snackbar("Error ", respond.toString(),
                                      duration: const Duration(seconds: 3),
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              }
                            },
                            child:  Text("Sign up",style: GoogleFonts.roboto(color:Colors.white,fontSize: 16),)),
                      ),
                    ],
                  ),
                ),
            ),
          ]
        ),
      )
    );
    
            
  }

}


