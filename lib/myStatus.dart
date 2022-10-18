import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Services/StoryServices/StoryServices.dart';
import 'package:chat_app/StoriesView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyStatus extends GetView<StoryServices> {
  const MyStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0F3460),
        title: const Text("MyStatus"),
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
          padding: const EdgeInsets.all(10),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => const StoriesView(),
                        arguments: controller.myStoryLinks);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                  controller.myStoryLinks[index].photo,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "0 views",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "10 minutes ago",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        offset: Offset(0, 50),
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        elevation: 0,
                        itemBuilder: (context) {
                          return [
                          const  PopupMenuItem(
                                child: Text("Forward",
                                    style: TextStyle(color: Colors.black))),
                            PopupMenuItem(
                              child:const Text(
                                "Delete",
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                 
                                 
                               
                            Get.defaultDialog(
                              content: Text("Delete 1 Story "),
                              cancel: Text("CANCEL"),
                              confirm: Text("CONFIRM"),
                              
                            );
                                
                              },
                            ),
                          ];
                        },
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 5,
                );
              },
              itemCount: controller.myStoryLinks.length),
        ),
      ),
    );
  }
}
