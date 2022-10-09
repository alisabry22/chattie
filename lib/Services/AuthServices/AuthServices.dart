import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/AuthScreen.dart';
import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/Services/AuthServices/LoginRespone.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../HomeScreen.dart';

class AuthServices extends GetxController {
  @override
  void onInit() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    String? token = sharedpref.getString("token");
    String? id=sharedpref.getString("ID");
   
  
    if (token != null && token.isNotEmpty && id!=null) {
      Get.offAll(()=>const HomeScreen());
        final msg=await AuthServices().RenewToken();
      

  if(msg!=true){
  
    Get.offAll(()=>const AuthScreen());
    sharedpref.remove("token");
    sharedpref.remove("ID");
    
      }
    } else {
      Get.offAll(() =>const AuthScreen ());
    }
    super.onInit();
  }
  
  RxBool loggedin = false.obs;

  Future signUpFunction(String username, String password, String email,String phone, String countrycode) async {
    String signupurl = "${Constants().url}/user/adduser";
    final usermodel = User(
        username: username,
        email: email,
        password: password,
        phone: phone,
        countrycode: countrycode,

      );

    final response = await http.post(Uri.parse(signupurl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(usermodel.userToJson()));
    if (response.statusCode == 200) {
      final data = loginResponseFromJson(response.body);
    
      saveTokenLocally(data.token);
      saveIDLoggedInUser(data.user.id);
      loggedin.value = true;
      return true;
    } else {
      loggedin.value = false;
      return jsonDecode(response.body)["msg"];
    }
  }
  Future RenewToken()async{
String renewurl="${Constants().url}/user/renewtoken";
SharedPreferences sharedprefs=await SharedPreferences.getInstance();
String? token=sharedprefs.getString("token");

try {
 final  response = await http.get(Uri.parse(renewurl),headers: {
    "Authorization":'Bearer $token'
  },
  
  );
  if(response.statusCode==200){
  var data=loginResponseFromJson(response.body);
  String token=data.token;
  saveTokenLocally(token);
  return true;

}
else
{
  return jsonDecode(response.body)["msg"];
}
} on TimeoutException catch (e){
  print(e);
 
  // TODO
}on SocketException catch(e){
  print(e);
}



  }

 

  Future loginFunction(String email, String password) async {
    String loginUrl = "${Constants().url}/user/login";
  
    
    final request = {"email": email, "password": password};


  final response = await http .post(Uri.parse(loginUrl), body: jsonEncode(request), headers: {
    "Content-Type": "application/json",
  });
  
  if (response.statusCode == 200) {
    loggedin.value = true;

    final data = loginResponseFromJson(response.body);
      
    saveTokenLocally(data.token);
    saveIDLoggedInUser(data.user.id);
    return true;
  } else {
    loggedin.value = false;
    return jsonDecode(response.body)["msg"];
  }
} 
  


  Future getUserInfo(String phone) async {
     String loginUrl = "${Constants().url}/user/getuser";
    SharedPreferences sharedprefs=await SharedPreferences.getInstance();
    String? token=sharedprefs.getString("token");
    final request={"phone":phone};
    final response =await http.post(Uri.parse(loginUrl),
        body:jsonEncode(request), headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        });

        if(response.statusCode==200){
          User data=User.fromJson(jsonDecode(response.body)["user"]);
          return data;
        }
        else{
          return jsonDecode(response.body)["msg"];
        }
  }
 Future saveIDLoggedInUser(String id)async{
     SharedPreferences sharedprefs=await SharedPreferences.getInstance();
  sharedprefs.setString("ID", id);
  }
  
  Future saveTokenLocally(String token) async {
    SharedPreferences tokenpref = await SharedPreferences.getInstance();
    tokenpref.setString("token", token);
  }

  Future deleteTokenLocally() async {
    SharedPreferences tokenpref = await SharedPreferences.getInstance();
    tokenpref.remove("token");
  }

  Future getCurrentUser()async{
    SharedPreferences sharedprefs=await SharedPreferences.getInstance();
  
    return   sharedprefs.getString("ID");
  }
}
