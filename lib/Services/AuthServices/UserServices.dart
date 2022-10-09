
import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/loginResponse.dart';
import 'package:chat_app/usermodels/UserModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserServices extends GetxController{

var signupUrl="${Constants().url}/user/adduser";

Future signupFunc(email,username,password,phone,countrycode)async{

var user=User(username: username,password: password,email: email,phone: phone,countrycode: countrycode);


final response=await http.post(Uri.parse(signupUrl),body:json.encode(user.userToJson()),headers: {
  'Content-Type':'application/json'
});

if(response.statusCode==200){
 final data=loginResponse.fromJson(response.body);

  await saveToken(data.token);
  return true;
}
else{

var decode=jsonDecode(response.body);
return decode["msg"];


}
}

Future saveToken(String token)async{
 SharedPreferences tokenprefs=await SharedPreferences.getInstance();
 
 tokenprefs.setString("token", token);
 
 }

}