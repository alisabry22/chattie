import 'package:chat_app/Services/StoryServices/StoryServices.dart';
import 'package:chat_app/Services/storyresponse/user_story_model.dart';
import 'package:chat_app/StoriesView.dart';
import 'package:chat_app/myStatus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:status_view/status_view.dart';

class StatusPage extends GetView<StoryServices> {
  final ImagePicker imagePicker = ImagePicker();
  String? currentuser;
  List<String> phones = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
            FloatingActionButton(
                  heroTag: "pen",
                    onPressed: () {},
                    child:const Icon(FontAwesomeIcons.pen),
                  ),
                  SizedBox(height: 5,),
                    FloatingActionButton(
                    heroTag: "camera",
                    onPressed: ()async {
                          final userstory = await controller
                                .uploadPhotoToServer( controller.currentuser.value);
                    },
                    child:const Icon(Icons.camera_alt),
                  ),
        ],
      ),
      body: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: GetX<StoryServices>(
                  builder: (controller) {
                    return controller.myStoryLinks.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              Get.to(() => const StoriesView(),
                                  arguments: controller.myStoryLinks);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Row(children: [
                                    StatusView(
                                      radius: 25,
                                      centerImageUrl:
                                          controller.myStoryLinks.last.photo,
                                      numberOfStatus:
                                          controller.myStoryLinks.length,
                                      strokeWidth: 2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "My Status",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Sans",
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            "Now",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: "Sans",
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.to(()=> const MyStatus());
                                  },
                                    child: const Icon(Icons.more_horiz,
                                        color: Colors.white)),
                              ],
                            ))
                        : InkWell(
                            onTap: ()  {
                                controller.uploadPhotoToServer(controller.currentuser.value);
    
                            
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: const AssetImage(
                                      "assets/images/avatar.png"),
                                  child: Stack(
                                    children: const [
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          radius: 10,
                                          child: Center(
                                              child: Icon(Icons.add_rounded)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Tap To Add Status",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          );
                  },
                ),
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
    
              GetX<StoryServices>(
                builder: (controller) {
                  return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Get.to(() => const StoriesView(),
                                  arguments:
                                      controller.usersStory[index].stories);
                            },
                            child: controller.usersStory[index].stories.isNotEmpty
                                ? Row(children: [
                                    StatusView(
                                      centerImageUrl: controller
                                          .usersStory[index].stories.last.photo,
                                      numberOfStatus: controller
                                          .usersStory[index].stories.length,
                                      strokeWidth: 2,
                                      radius: 25,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${controller.usersStory[index].username}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ])
                                : Container());
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: controller.usersStory.length);
                },
              )
            ],
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
