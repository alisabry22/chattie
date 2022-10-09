import 'package:chat_app/Models/StoryModel.dart';

class UserStoryModel {
  String userId, username,email, phone, countrycode;
  List<StoryModel> stories;

  UserStoryModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.countrycode,
    required this.stories,
  });

  factory UserStoryModel.fromJson(Map<String, dynamic> json) {
  final  userId = json["_id"];
   final username = json["username"];
    final email=json["email"];
    final phone=json["phone"];
    final countrycode=json["countrycode"];
    final userstories=(json["stories"]??[])as List<dynamic>;
    final stories=userstories.isNotEmpty?userstories.map<StoryModel>((e) => StoryModel.fromJson(e),).toList():<StoryModel>[];
    return UserStoryModel(
        userId: userId,
        email: email,
        username: username,
        phone: phone,
        countrycode: countrycode,
        stories: stories);
  }
}
