
import 'package:chat_app/Models/user.dart';

class StoryModel{

late String photo;
late String id;
late User user;


StoryModel({
  required this.photo,
  required this.id,
  required this.user
});

 factory StoryModel.fromJsonallusers(Map<String,dynamic>json){
 final id=json["_id"];
 final photo=json["storyLink"];
 return StoryModel(photo: photo, id: id, user: User(email: "",countrycode: "",phone: "",id: "",username: ""));

 }


 factory StoryModel.fromJsonAddedStory(Map<String,dynamic>json){
  final id=json["_id"];
 final photo=json["storyLink"];
 final user=json["userId"]!=null ?User.fromJson(json["userId"]): User(username: "", email: "", phone: "", countrycode: "");
 return StoryModel(photo: photo, id: id, user: user);
 }




}
