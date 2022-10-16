import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/ObjectBox/UserBox.dart';
import 'package:chat_app/Services/PhoneServices/PhoneResponse.dart';
import 'package:chat_app/objectbox.g.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/User.dart';
import '../../main.dart';

class phoneController extends GetxController{

   RxList<String> phones=RxList.empty();
    RxList<Contact> contacts =RxList.empty();
    RxBool issearching = false.obs;
      RxList<User> users = RxList.empty();
  var responsePhoneController;

@override
  void onInit() {
    
    super.onInit();
    requestContacts();
    getPhonesList(contacts);


  }
  Future getPhonesList(RxList<Contact>contacts)async{
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
    
    

  void   requestContacts() async {
       SharedPreferences sharedprefs=await SharedPreferences.getInstance();
    if (await FlutterContacts.requestPermission()) {
      List<Contact> democontact = await FlutterContacts.getContacts(withProperties: true);

if(democontact.isNotEmpty){
 democontact.forEach((element) {
element.phones.forEach((phone) {
  phones.add(phone.number.replaceAll(" ", "").toString());
});
 });
 
 String? id = sharedprefs.getString("ID");

Query<UserBox> query=objectBox.userBox.query(UserBox_.userID.equals(id!)).build();
UserBox? userBox=query.findFirst();

  userBox!.phones=phones.toSet().toList();
  objectBox.userBox.put(userBox);


  contacts.value=democontact;

      
}
      
      responsePhoneController = await getPhonesList(contacts);
      if (responsePhoneController is List) {
      users.value=responsePhoneController;
      }
    }
  }


    void runfilter(String value)async{
    if(value.isNotEmpty){
      var filterResult;
      filterResult= contacts.where((element) => element.displayName.toLowerCase().contains(value.toLowerCase())).toList();
      
      
        contacts.value=filterResult;
    
    
    }
    else{
      final dummylist=await FlutterContacts.getContacts(withProperties: true);
   
        contacts.value=dummylist;
    }
}
  }
