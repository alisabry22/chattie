import 'package:chat_app/Services/AuthServices/auth_services.dart';
import 'package:chat_app/Services/AuthServices/login_response.dart';
import 'package:chat_app/home_screen.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'Models/ObjectBox/UserBox.dart';

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
              child: Stack(children:const [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(FontAwesomeIcons.circlePlus)),
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
                            Color(0xff3120E0),
                            Color(0xff3B9AE1),
                          ]),
                        ),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              disabledForegroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final respond =
                                    await AuthServices().signUpFunction(
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
                                 emailController.text.trim(),
                                  phoneController.text.trim(),
                                  countryCode,
                                );
                              
                                if (respond[0] == true &&
                                    respond[1] is LoginResponse) {
                                  LoginResponse userresponse = respond[1];
                                  //store user data Locally
                                  UserBox userBox = UserBox(
                                    userID: userresponse.user.id,
                                    username:usernameController.text,
                                    email:emailController.text,
                                    phone: phoneController.text.trim(),
                                    countrycode: countryCode,
                                    phones: [],
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
                            child: const Text("Sign up")),
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


