import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chat_app/Constants/constants.dart';
import 'package:chat_app/Models/ObjectBox/user_box.dart';
import 'package:chat_app/Services/PhoneServices/phone_response.dart';
import 'package:chat_app/objectbox.g.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/user.dart';
import '../../main.dart';

class PhoneController extends GetxController{

   RxList<String> phones=RxList.empty();
    RxList<Contact> contacts =RxList.empty();
    RxBool issearching = false.obs;
      RxString userID="".obs;
      RxList<User>searchedphones=RxList.empty();
     List<Contact>deletedContacts=[];
        RxBool isloading=false.obs;


@override
  void onInit()async {
         SharedPreferences sharedprefs=await SharedPreferences.getInstance();
        userID.value = sharedprefs.getString("ID")!;
        userID.refresh();
    super.onInit();
    requestContacts();


  }
  Future  getPhonesList(RxList<Contact>contacts)async{
  String phoneHtppUrl="${await Constants().detectDevice()}/phone/searchphone";
    contacts.forEach((element) {
           if(element.phones!.isNotEmpty)
      {
       
          phones.add(element.phones!.first.value!.replaceAll(" ", ""));
       
      }
     


    });

    try {
     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     String? token= sharedPreferences.getString("token");
  final response=await http.post(Uri.parse(phoneHtppUrl),body: json.encode(phones),headers: {
    "Content-Type": "application/json",
    "Authorization":'Bearer $token'
  });
  
  if(response.statusCode==200){
  
   final data= phoneResponseFromJson(response.body);
 
    searchedphones.value=data.user;
    
  
    searchedphones.refresh();
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
    
    

  Future   requestContacts() async {
  

      List<Contact> democontact = await ContactsService.getContacts(withThumbnails: false,photoHighResolution: false);
      print(democontact.length);


      //to do not include spaces in numbers 

      contacts.forEach((element) {
      if(element.phones!=null){
        element.phones!.forEach((phone) {
          phone.value!.replaceAll(" ", "");
        });
      }
       });
    // for( var element in democontact){
    //  for(var phone in element.phones!){
    //   if(element.phones!=null){
    //        print("phones for ${element.displayName} ${phone.value}");
    //   }
   
    //  }
    // }
if(democontact.isNotEmpty ){
 for (var element in democontact) {

    for (var phone in element.phones!) {
  phones.add(phone.value!.replaceAll(" ", "").toString());
}
  }

 }
 
 

Query<UserBox> query=objectBox.userBox.query(UserBox_.userID.equals(userID.value)).build();
UserBox? userBox=query.findFirst();


  userBox!.phones=phones.toSet().toList();
  objectBox.userBox.put(userBox);


  contacts.value=democontact;
  contacts.refresh();
await getPhonesList(contacts);
      
}

    
  


    void runfilter(String value)async{
    if(value.isNotEmpty){
      var filterResult;
      filterResult= contacts.where((element) => element.displayName!.toLowerCase().contains(value.toLowerCase())).toList();
      
      
        contacts.value=filterResult;
    
    
    }
    else{
      final dummylist=await ContactsService.getContacts(withThumbnails: false,photoHighResolution: false);
   
        contacts.value=dummylist;
    }
}
  }
