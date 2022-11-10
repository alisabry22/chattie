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
    super.onInit();
    requestContacts();


  }
  Future  getPhonesList()async{
  String phoneHtppUrl="${await Constants().detectDevice()}/phone/searchphone";


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

//remove contacts that use app from all contacts list
   removeAppContactsFromAll();
    
  
    searchedphones.refresh();
    return data.user;
  }
  else{
  
    return jsonDecode(response.body)["msg"];
  }
} catch(e){
  print(e.toString());
}
  }
    
    

  Future   requestContacts() async {
Query<UserBox> query=objectBox.userBox.query().build();
UserBox? userBox=query.findFirst();


    //empty phones first 
    phones.value=[];

      List<Contact> democontact = await ContactsService.getContacts(withThumbnails: false,photoHighResolution: false);


      //to not include spaces in numbers to bet sent to api clearly
  Contact mycontactToDelete=Contact();
      for (var contact in democontact){
        if(contact.phones!=null && contact.phones!.isNotEmpty){
          for (var phone in contact.phones!){
           
          phone.value=  phone.value!.replaceAll(" ", "");
             if(phone.value==userBox!.phone){
              mycontactToDelete=contact;
             }
        }
        }
         
      }
      //to remove my contact if present in contacts
 democontact.remove(mycontactToDelete);


//add phones to the list of phones 
  for (var contact in democontact) {
    if(contact.phones!=null){
      for (var phone in contact.phones!) {
        phones.add(phone.value!);
      }
    }
  }

  //save phones localy to this user   
  userBox!.phones=phones;
  objectBox.userBox.put(userBox);


  contacts.value=democontact;
  contacts.refresh();
await getPhonesList();

isloading.value=false;
      
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

void removeAppContactsFromAll(){
   List<int>indexes_to_Delete=[];
    for (var element in searchedphones) {
    for(int i=0 ; i<contacts.length;i++){
      if(contacts[i].phones!=null){
        for(int k=0 ; k<contacts[i].phones!.length ; k++){
          if(contacts[i].phones![k].value==element.phone){
            indexes_to_Delete.add(i);
          }
        }
      }
    }
    }
List<Contact>contactsToRemove=[];

for (var element in indexes_to_Delete) { 
  contactsToRemove.add(contacts[element]);
}

for (var element in contactsToRemove) { 
  contacts.remove(element);
}

  contacts.refresh();
}
  }
