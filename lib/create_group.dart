import 'package:chat_app/Services/PhoneServices/phone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroup extends GetView<PhoneController> {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff002B5B),
      appBar: AppBar(
        backgroundColor: const Color(0xff002B5B),
        leading: GetX<PhoneController>(
          builder: (controller) {
            return controller.issearching.value
                ? BackButton(
                    onPressed: () {
                      controller.issearching.value =
                          !controller.issearching.value;
                    },
                  )
                : BackButton(
                    onPressed: () {
                      Get.back();
                    },
                  );
          },
        ),
        title: GetX<PhoneController>(
          builder: (controller) {
            return controller.issearching.value
                ? TextField(
                    onChanged: ((query) =>
                        controller.filterUsersInApp(query)),
                    cursorColor: Colors.white,
                    style: GoogleFonts.roboto(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New group ",
                        style: GoogleFonts.roboto(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Add participants ",
                        style: GoogleFonts.roboto(
                            color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.issearching.value = true;
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            GetX<PhoneController>(builder:(controller) {
              return SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection:Axis.horizontal ,
                  itemBuilder: (context,index){
                  return Row(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(controller.selectedUsers[index].profilephoto),),  //selected user
                      Text(controller.selectedUsers[index].username),
                    ],
                  );
                }, separatorBuilder: (context,index){
                  return const  SizedBox(width: 10,);
                }, itemCount: controller.selectedUsers.length),
              );
            },
             ),
            GetX<PhoneController>(
              builder: (controller) {
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      print(controller.searchedphonesFilter.length);
                      return InkWell(
                        onTap: (){
                          if(controller.selectedUsers.contains(controller.searchedphonesFilter[index])){
                            controller.selectedUsers.remove(controller.searchedphonesFilter[index]);
                          }else{
    controller.selectedUsers.add(controller.searchedphonesFilter[index]);

                          }
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(controller
                                  .searchedphonesFilter[index].profilephoto)),
                          title: Text(
                            controller.searchedphonesFilter[index].username,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            controller.searchedphonesFilter[index].quote,
                            style: GoogleFonts.roboto(color: Colors.white60),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: controller.searchedphonesFilter.length);
              },
            ),
          ],
        ),
      ),
    );
  }
}
