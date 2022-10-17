import 'dart:convert';

import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/StoryModel.dart';
import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/Services/storyresponse/storyResponse.dart';
import 'package:chat_app/Services/storyresponse/user_story_model.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/objectbox.g.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../Models/ObjectBox/UserBox.dart';
import '../../socketServices/socketservices.dart';

class StoryServices extends GetxController {
    RxList<StoryModel> myStoryLinks = RxList.empty();
      RxList<UserStoryModel> usersStory =RxList.empty();
      RxString currentuser="".obs;
@override
  void onInit()async {
    
       SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if(sharedPrefs.getString("ID")!=null) {
      currentuser.value = sharedPrefs.getString("ID")!;
    }
    super.onInit();
    getmyAllStories();
    getOthersStory();
    storySocketService();
  }
  Future uploadStoryToCloud(XFile file, String id) async {
    final cloudinary = CloudinaryPublic("dibhdgsri", "jsfjqynz");
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path,
            resourceType: CloudinaryResourceType.Image, folder: id),
      );

      return response.secureUrl;
    } catch (e) {
      print(e.toString());
    }
  }

  void storySocketService(){

      Socket socket=  Get.find<SocketServices>().socket;
  
      socket.on("insertedStory", (data){
        print(data as Map<String,dynamic>);
       // UserStoryModel userStoryModel=UserStoryModel.fromJson(data as Map<String,dynamic>);
        

      });
  }

  Future uploadPhotoToServer( String userid) async {
     ImagePicker imagePicker = ImagePicker();

  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

  if (image != null) {
  String storyImageurl = await uploadStoryToCloud(image, userid);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    String storyurl = "${await Constants().detectDevice()}/story/uploadstory";
    final request = {"storyurl": storyImageurl};
    final response = await http.post(Uri.parse(storyurl),
        body: jsonEncode(request),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });

    if (response.statusCode == 200) {
      final data = await getmyAllStories();
      return data;
    } else {
      return jsonDecode(response.body)["msg"];
    }
  }

    
  }

  Future getmyAllStories() async {
 
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String? token = sharedPrefs.getString("token");
    String getStories = "${await Constants().detectDevice()}/story/getcurrentstory";

    try {
  final response = await http.get(Uri.parse(getStories),
      headers: {"Authorization": "Bearer $token"});
  
  if (response.statusCode == 200) {
  
     final data = StoryResponseFromJsonCurrentUser(response.body);

    
    myStoryLinks.value=data.currentuser!.stories;
    myStoryLinks.refresh();
  } else {
    
   print(jsonDecode(response.body)["msg"]) ;
  }
}  catch (e) {
  print(e.toString());
  }
  }


  


  Future getOthersStory() async {
   
Query<UserBox> query=objectBox.userBox.query(UserBox_.userID.equals(currentuser.value)).build();

UserBox? userBox=query.findFirst();

List<String>phones=objectBox.userBox.get(userBox!.id)!.phones;
    String storyurls = "${await Constants().detectDevice()}/story/getotherstory";
        SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String? token = sharedPrefs.getString("token");
    try {
  final response = await http
      .post(Uri.parse(storyurls), body: json.encode(phones), headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      });
  
      if(response.statusCode==200){
        
        final data=StoryResponseFromJson(response.body);
        usersStory.value=data.users!;
        update();
      }
      else{
        print(jsonDecode(response.body)["msg"]) ;
      }
}  catch (e) {
print(e.toString());
}
  }
}
