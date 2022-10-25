import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_app/Constants/constants.dart';
import 'package:chat_app/Models/user.dart';
import 'package:chat_app/Services/AuthServices/login_response.dart';
import 'package:chat_app/auth_screen.dart';
import 'package:chat_app/home_screen.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthServices extends GetxController {
 
  
   RxList<Contact> contacts=RxList.empty();
    RxBool islogin=true.obs;
    RxBool obscurevalue=false.obs;


  @override
  void onInit() async {
    
    
        SharedPreferences sharedpref = await SharedPreferences.getInstance();
      String? token = sharedpref.getString("token");
    String? id=sharedpref.getString("ID");

  
    if (token != null && token.isNotEmpty && id!=null) {
      Get.offAll(()=>const HomeScreen());
        final msg=await renewToken();

      

  if(msg!=true){
  
    Get.offAll(()=> AuthScreen());
    sharedpref.remove("token");
    sharedpref.remove("ID");
    
      }
    } else {
      Get.offAll(() => AuthScreen ());
    }
    super.onInit();
  }
  
 
Future requestContacts ()async{
await FlutterContacts.requestPermission();

}


  Future signUpFunction(String username, String password, String email,String phone, String countrycode,String profilephoto) async {
    String signupurl = "${await Constants().detectDevice()}/user/adduser";
    final usermodel = User(
        username: username,
        email: email,
        password: password,
        phone: phone,
        countrycode: countrycode,
        profilephoto: profilephoto,
        quote: ""
      );

    final response = await http.post(Uri.parse(signupurl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(usermodel.userToJson()));
    if (response.statusCode == 200) {
      final data = loginResponseFromJson(response.body);
      saveTokenLocally(data.token);
      saveIDLoggedInUser(data.user.id);

      return [true,data];
    } else {
      
      return [false,jsonDecode(response.body)["msg"]];
    }
  }
  Future renewToken()async{
String renewurl="${await Constants().detectDevice()}/user/renewtoken";
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
    String loginUrl =await Constants().detectDevice();
    loginUrl="$loginUrl/user/login";
    
    final request = {"email": email, "password": password};


  final response = await http .post(Uri.parse(loginUrl), body: jsonEncode(request), headers: {
    "Content-Type": "application/json",
  });
  
  if (response.statusCode == 200) {
   

    final data = loginResponseFromJson(response.body);
    saveTokenLocally(data.token);
    saveIDLoggedInUser(data.user.id);
    return [true,data];
  } else {
    return [false,jsonDecode(response.body)["msg"]];
  }
} 
  


  Future getUserInfo(String phone) async {
     String loginUrl = "${await Constants().detectDevice()}/user/getuser";
    SharedPreferences sharedprefs=await SharedPreferences.getInstance();
    String? token=sharedprefs.getString("token");
    final request={"phone":phone};
    try {
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
} catch (e) {
print(e.toString());
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

  Future pickImage()async{

    XFile? file=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(file!=null){
      return file;
    }
    else 
    {
      return null;
    }
  }

  Future uploadStoryToCloud(XFile file, String id) async {
    final cloudinary = CloudinaryPublic("dibhdgsri", "jsfjqynz");
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path,
            resourceType: CloudinaryResourceType.Image, folder: "$id/profile"),
      );

      return response.secureUrl;
    } catch (e) {
      print(e.toString());
    }
  }

  // Future updateProfile(String profilephoto)async{
  //   String updateProfileUrl="${Constants().detectDevice()}/user/editprofile";
  //   SharedPreferences sharedprefs=await SharedPreferences.getInstance();
  //   String? token=sharedprefs.getString("token");


  //   final response=await http.post(Uri.parse(updateProfileUrl),body: ,headers:
  //   {"Content-Type": "application/json",
  //       'Authorization': 'Bearer $token'});

  //   if(response.statusCode==200){

  //   }else{

  //     print(jsonDecode(response.body));
  //   }
  // }
}
