import 'dart:convert';

import 'package:chat_app/Constants/Constants.dart';
import 'package:chat_app/Models/StoryModel.dart';
import 'package:chat_app/Services/storyresponse/storyResponse.dart';
import 'package:chat_app/main.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryServices {
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
  
    
     return data.currentuser;
     
  } else {
    
   return jsonDecode(response.body)["msg"];
  }
}  catch (e) {
  print(e.toString());
  }
  }

  Future getOthersStory(List<String> phones) async {
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
        return data;
      }
      else{
        return jsonDecode(response.body)["msg"];
      }
}  catch (e) {
print(e.toString());
}
  }
}
