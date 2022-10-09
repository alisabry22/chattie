import 'package:chat_app/HomeScreen.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/AuthServices/AuthServices.dart';
import 'Models/ObjectBox/UserBox.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  String countryCode = "+20";
  bool obscurevalue = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        gradient: LinearGradient(colors: [
          Color(0xff002B5B),
          Color(0xff2B4865),
        ]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    style:const TextStyle(color: Colors.white),
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
                    controller: passwordController,
                    keyboardType: TextInputType.number,
                    obscureText: obscurevalue,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              obscurevalue = !obscurevalue;
                            });
                          },
                          child: obscurevalue
                              ?const Icon(Icons.lock_open)
                              :const Icon(Icons.lock)),
                      hintText: "Password",
                      hintStyle:const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    style:const TextStyle(color: Colors.white),
                    controller: emailController,
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
                  controller: phoneController,
                  autovalidateMode: AutovalidateMode.disabled,
                  disableLengthCheck: true,
                  dropdownTextStyle:const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  pickerDialogStyle:
                      PickerDialogStyle(backgroundColor: Colors.white),
                  style:const TextStyle(color: Colors.white),
                  onCountryChanged: (str) {
                    countryCode = str.dialCode.toString();
                  },
                ),
              const  Spacer(),
                GetX<AuthServices>(
                  builder: ((controller) {
                    return Container(
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
                          onPressed: controller.loggedin.value
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final respond =
                                        await AuthServices().signUpFunction(
                                      usernameController.text.trim(),
                                      passwordController.text.trim(),
                                      emailController.text.trim(),
                                      phoneController.text.trim(),
                                      countryCode,
                                    );

                                    if (respond == true) {
                                      //store user data Locally
                                      UserBox userBox =  UserBox(
                                          username: usernameController.text,
                                          email: emailController.text,
                                          phone: phoneController.text.trim(),
                                          countrycode: countryCode,
                                          phones: []
                                          );
                                        SharedPreferences sharedprefs=await SharedPreferences.getInstance();
                                        
                                        int id=  objectBox.userBox.put(userBox);
                                        sharedprefs.setInt("localId", id);

                                      Get.offAll(() =>const HomeScreen());
                                    } else {
                                      Get.snackbar("Error ", respond.toString(),
                                          duration: const Duration(seconds: 3),
                                          snackPosition: SnackPosition.BOTTOM);
                                    }
                                  }
                                },
                          child: const Text("Sign up")),
                    );
                  }),
                ),
              ],
            )),
      ),
    );
  }
}
