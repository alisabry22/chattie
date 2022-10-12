import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Services/PhoneServices/PhoneResponse.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class phoneController extends GetxController{

   List<String> phones=[];
  Future getPhonesList(List<Contact>contacts)async{
  String phoneHtppUrl="${await Constants().detectDevice()}/phone/searchphone";
    contacts.forEach((element) {
           if(element.phones.isNotEmpty)
      {
       
          phones.add(element.phones.first.number.replaceAll(" ", ""));
       
      }
     


    });

    try {
     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     String? token= sharedPreferences.getString("token");
     print("token$token");
  final response=await http.post(Uri.parse(phoneHtppUrl),body: json.encode(phones),headers: {
    "Content-Type": "application/json",
    "Authorization":'Bearer $token'
  });
  
  if(response.statusCode==200){
  
   final data= phoneResponseFromJson(response.body);
   print(data);
  
    return data.user;
  }
  else{
  
    return jsonDecode(response.body)["msg"];
  }
} on TimeoutException catch (e) {
print(e);
}
on SocketException catch(e){
  print(e);
}
  }
    
    
  }
