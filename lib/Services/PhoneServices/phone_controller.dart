import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
   //contacts that remains with out changes
    RxList<Contact> allContacts =RxList.empty();

    //contacts that can be used in filter criteria
    RxList<Contact> contactsToShow=RxList.empty();
    RxBool issearching = false.obs;
      RxString userID="".obs;
      RxList<User>searchedphones=RxList.empty();
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
 //  removeAppContactsFromAll();
    
  
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
 List< Contact> mycontactToDelete=[];
      for (var contact in democontact){
        if(contact.phones!=null || contact.phones!.isNotEmpty  || contact.displayName!=null){
          for (var phone in contact.phones!){
           
          phone.value=  phone.value!.replaceAll(" ", "");
             if(phone.value==userBox!.phone){
              mycontactToDelete.add(contact);
             }
        }
        }
        else{
          mycontactToDelete.add(contact);
        }
         
      }
      //to remove my contact if present in contacts
for(var element in mycontactToDelete){
  democontact.remove(element);
}

  List<Contact> emptyNullValues=[];
for (var element in democontact){
 if(element.displayName==null){
  emptyNullValues.add(element);
 }
}
//remove null values 
democontact.removeWhere((element) => emptyNullValues.contains(element));
allContacts.value=democontact;
allContacts.refresh();
contactsToShow.value=allContacts;

contactsToShow.refresh();

//add phones to the list of phones 
  for (var contact in allContacts) {
    if(contact.phones!=null){
      for (var phone in contact.phones!) {
        phones.add(phone.value!);
      }
    }
  }

  //save phones localy to this user   
  userBox!.phones=phones;
  objectBox.userBox.put(userBox);



await getPhonesList();

isloading.value=false;
      
}

 void runfilter(String query)async{
      log("run filter called $query");
        List<Contact> filterResult=[];
       
        allContacts.refresh();
      filterResult.addAll(allContacts);
     
    if(query.isNotEmpty){
      List<Contact>dummySearchList=[];
     filterResult.forEach((contact) {
      if(contact.displayName!.toLowerCase().contains(query.toLowerCase())){
        dummySearchList.add(contact);
      }
     });

       
        contactsToShow.value=dummySearchList;
      contactsToShow.refresh();
    
    }
    else{
 
        contactsToShow.value=allContacts;
        contactsToShow.refresh();
    }
}

// void removeAppContactsFromAll(){
//    List<int>indexes_to_Delete=[];
//     for (var element in searchedphones) {
//     for(int i=0 ; i<contactsToShow.length;i++){
//       if(contactsToShow[i].phones!=null){
//         for(int k=0 ; k<contactsToShow[i].phones!.length ; k++){
//           if(contactsToShow[i].phones![k].value==element.phone){
//             indexes_to_Delete.add(i);
//           }
//         }
//       }
//     }
//     }
// List<Contact>contactsToRemove=[];

// for (var element in indexes_to_Delete) { 
//   contactsToRemove.add(contactsToShow[element]);
// }

// for (var element in contactsToShow) { 
//   contactsToShow.remove(element);
// }

//   contactsToShow.refresh();
// }
  }
