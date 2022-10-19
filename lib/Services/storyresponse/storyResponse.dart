import 'dart:convert';


import 'package:chat_app/Models/StoryModel.dart';
import 'package:chat_app/Services/storyresponse/user_story_model.dart';

class StoryResponse{

 UserStoryModel? currentuser; 
List<UserStoryModel>? users;


 
//parsing all users stories
  StoryResponse.fromJson(List<dynamic>json):
  users=json.map<UserStoryModel>((e) => UserStoryModel.fromJson(e as Map<String,dynamic>)).toList();

//parsing current user stories
StoryResponse.fromJsonCurrent(Map<String,dynamic>json):
  currentuser=UserStoryModel.fromJson(json);



}


StoryResponse StoryResponseFromJson(String str)=>StoryResponse.fromJson(jsonDecode(str)["stories"] as List);

StoryResponse StoryResponseFromJsonCurrentUser(String str)=>StoryResponse.fromJsonCurrent(jsonDecode(str)["stories"]);