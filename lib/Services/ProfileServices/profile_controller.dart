import 'dart:convert';
import 'dart:io';

import 'package:chat_app/Constants/constants.dart';
import 'package:chat_app/Models/ObjectBox/user_box.dart';
import 'package:chat_app/main.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ProfileController extends GetxController{

RxString pickedImagePath="".obs;
RxBool imagedPicked=false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future pickImage()async{

    XFile? file=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(file!=null){
      UserBox? userBox=   objectBox.userBox.getAll().first;
   if(userBox!=null){
    userBox.personalphoto=await File(file.path).readAsBytes();
    objectBox.userBox.put(userBox);
   }
      return file;
    }else{
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

   Future updateProfilephoto(String profilephoto)async{
    String updateProfileUrl="${await Constants().detectDevice()}/user/editprofilephoto";
    print(updateProfileUrl);
    SharedPreferences sharedprefs=await SharedPreferences.getInstance();
    String? token=sharedprefs.getString("token");

    final request={"profilephoto":profilephoto};
    final response=await http.post(Uri.parse(updateProfileUrl),body:jsonEncode(request) ,headers:
    {"Content-Type": "application/json",
        'Authorization': 'Bearer $token'});

    if(response.statusCode==200){

      return true;
    }else{

      return jsonDecode(response.body)["msg"];
    }
  }

   Future updateProfileQuote(String quote)async{
    String updateProfileUrl="${Constants().detectDevice()}/user/editquote";
    SharedPreferences sharedprefs=await SharedPreferences.getInstance();
    String? token=sharedprefs.getString("token");


    final response=await http.post(Uri.parse(updateProfileUrl),body:json.encode(quote) ,headers:
    {"Content-Type": "application/json",
        'Authorization': 'Bearer $token'});

    if(response.statusCode==200){


    }else{

      print(jsonDecode(response.body));
    }
  }

  


}