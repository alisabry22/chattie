import 'package:chat_app/Models/StoryModel.dart';
import 'package:chat_app/Models/User.dart';
import 'package:chat_app/Services/StoryServices/StoryServices.dart';
import 'package:chat_app/Services/storyresponse/storyResponse.dart';
import 'package:chat_app/Services/storyresponse/user_story_model.dart';
import 'package:chat_app/StoriesView.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:status_view/status_view.dart';

import 'Models/ObjectBox/UserBox.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final ImagePicker imagePicker = ImagePicker();
  List<StoryModel> myStoryLinks = [];
  String? currentuser;
  List<String> phones = [];
  List<StoryModel> stories = [];
  List<UserStoryModel> usersStory = [];
  @override
  void initState() {
    super.initState();
    getAllMyStories();
    getCurrentUser();
    getOthersStory();
  }

  Future getAllMyStories() async {
    final data = await StoryServices().getmyAllStories();
    if (data != null && data is UserStoryModel) {
      setState(() {
        myStoryLinks = data.stories;
      });
    }
   
  }

Future getOthersStory()async{
   SharedPreferences sharedprefs = await SharedPreferences.getInstance();
 String? id = sharedprefs.getString("ID");

Query<UserBox> query=objectBox.userBox.query(UserBox_.userID.equals(currentuser!)).build();
UserBox? userBox=query.findFirst();
     var data = await StoryServices()
        .getOthersStory(objectBox.userBox.get(userBox!.id)!.phones);

        
    if (data is StoryResponse && data.users != null) {

      setState(() {
        usersStory = data.users!;
      });
    } else {
    Get.snackbar("Error", data.toString(),snackPosition: SnackPosition.BOTTOM,duration: const Duration(milliseconds: 300));
    }
}
  Future getCurrentUser() async {
      SharedPreferences sharedprefs = await SharedPreferences.getInstance();

    String? userid = sharedprefs.getString("ID");

   

    if (userid != null) {
      setState(() {
        currentuser = userid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff002B5B),
              Color(0xff2B4865),
            ]),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(children: [
                    myStoryLinks.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              Get.to(() => const StoriesView(),
                                  arguments: myStoryLinks);
                            },
                            child: StatusView(
                              radius: 25,
                              centerImageUrl: myStoryLinks.last.photo,
                              numberOfStatus: myStoryLinks.length,
                              strokeWidth: 2,
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                               final userstory = await StoryServices()
                                    .uploadPhotoToServer( currentuser!);
          
                                if (userstory is UserStoryModel) {
                                  setState(() {
                                    myStoryLinks = userstory.stories;
                                  });
                                }
                              
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  const AssetImage("assets/images/avatar.png"),
                              child: Stack(
                                children: const [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      radius: 10,
                                      child: Center(child: Icon(Icons.add_rounded)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Status",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Sans",
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              myStoryLinks.isNotEmpty ? "Now" : "Tap To Add Status",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ]),
                    ),
                  ]),
                ),
          
                const Text(
                  "Recent Updates",
                  style:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
          
                const SizedBox(
                  height: 10,
                ),
          
                //Listview for displaying status of users which they are in your contacts list
                usersStory.isNotEmpty
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                      
                         
                            return InkWell(
                              onTap: (){
                                Get.to(()=>const StoriesView(),arguments: usersStory[index].stories);
                              },
                              child:usersStory[index].stories.isNotEmpty?  Row(
                              children: [
                               StatusView(
                                  centerImageUrl: usersStory[index].stories.last.photo,
                                  numberOfStatus: usersStory[index].stories.length,
                                  strokeWidth: 2,
                                  radius: 25, 
                                                  
                                  ),
                                const  SizedBox(width: 5,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${usersStory[index].username}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                              ]
                                                  ):Container()
                            );
                        
                          
              
          
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: usersStory.length)
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<XFile?> pickImage() async {
  ImagePicker imagePicker = ImagePicker();

  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    return image;
  }
  return null;
}
