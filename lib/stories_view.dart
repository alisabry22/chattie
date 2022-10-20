import 'package:chat_app/Models/story_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:story_view/story_view.dart';

class StoriesView extends StatefulWidget {
  const StoriesView({Key? key}) : super(key: key);

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  final storyController = StoryController();
  List<StoryModel> stories = Get.arguments;
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    print(stories);
    super.initState();
    for (var element in stories) {
      storyItems.add(
          StoryItem.pageImage(url: element.photo, controller: storyController));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        actions: [
        PopupMenuButton(itemBuilder:(context) {
         return const [
            PopupMenuItem(child: Text("Message")),
            PopupMenuItem(child:Text("Voice Call")),
            PopupMenuItem(child:Text("Video Call")),
          ];
        },),
        ],
        elevation: 0,
        backgroundColor: Colors.black,

        leading: IconButton( icon:const Icon(Icons.arrow_back_rounded),onPressed: () {Get.back(); },),
        centerTitle: false,
        title: Row(
          children: [
               
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 18,
            backgroundImage:NetworkImage(stories.last.photo),
          ),
        ),
       const SizedBox(width: 3,),
       const Text("MyStatus",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
          ],
        ),
 ),
      body: StoryView(
        onStoryShow: (value) {},
        storyItems: storyItems,
        controller: storyController,
        onComplete: () {
          Get.back();
        },
      ),
    );
  }
}
