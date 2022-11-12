import 'package:chat_app/Services/MessageServices/message_services.dart';
import 'package:chat_app/socketServices/socket_services.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends GetView<MessageServices> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
              child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
               const BackButton(
                  color: Colors.white,
                ),
               const SizedBox(
                  width: 2,
                ),
                controller.user.value.profilephoto.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(controller.user.value.profilephoto),
                        radius: 18,
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/avatar.png"),
                        radius: 18,
                      ),
              const  SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(controller.user.value.username,style: GoogleFonts.roboto(color:Colors.white),),
                  const SizedBox(height: 6,),
                  Text("online",style: GoogleFonts.roboto(color:Colors.white.withOpacity(0.2)),),
                  ],
                )),
              ],
            ),
          )),
          backgroundColor: const Color(0xff002B5B)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: GetX<MessageServices>(
            builder: (controller) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.messages.length) {
                      return Container(
                        height: 50,
                      );
                    }

                    if (controller.messages[index].senderId ==
                        controller.currentuser.value) {
                      controller.issender.value = true;
                    }
                    return BubbleSpecialThree(
                      text: controller.messages[index].message,
                      tail: false,
                      textStyle: const TextStyle(fontSize: 16),
                      color: controller.issender.value
                          ? const Color(0xFF1B97F3)
                          : const Color(0xFFE8E8EE),
                      isSender: controller.issender.value,
                    );
                  });
            },
          )),
          Row(children: [
            Container(
              height: 50,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey.shade300,
              ),
              child: TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: "Message",
                  prefixIcon: Icon(Icons.emoji_emotions),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                      onPressed: () {
                        Socket socket = Get.find<SocketServices>().socket;

                        socket.emit("sendMessage", {
                          "content": messageController.text.trim(),
                          "sender": controller.currentuser.value,
                          "chatId": controller.chatId.value,
                        });

                        messageController.text = "";
                      },
                      icon: const Icon(Icons.send_rounded))),
            ),
          ]),
        ],
      ),
    );
  }
}
