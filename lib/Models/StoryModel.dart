class StoryModel{

String photo;
String id;



StoryModel({
  required this.photo,
  required this.id,

});

  StoryModel.fromJson(Map<String,dynamic>json):
  id=json["_id"],
  photo=json["storyLink"];


}
