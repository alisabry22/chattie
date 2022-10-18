import 'package:chat_app/Models/User.dart';

class StoryModel{

late String photo;
late String id;
late User user;


StoryModel({
  required this.photo,
  required this.id,
  required this.user
});

  StoryModel.fromJson(Map<String,dynamic>json):
  id=json["_id"],
  photo=json["storyLink"],
  user=json["userId"]!=null?User.fromJson(json["userId"]):User(username: "", email: "", phone: "", countrycode: "");


}
