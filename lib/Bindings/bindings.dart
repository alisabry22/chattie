import 'package:chat_app/Services/AuthServices/auth_services.dart';
import 'package:chat_app/Services/ChatServices/chat_services.dart';
import 'package:chat_app/Services/MessageServices/message_services.dart';
import 'package:chat_app/Services/PhoneServices/phone_controller.dart';
import 'package:chat_app/Services/StoryServices/story_services.dart';
import 'package:chat_app/socketServices/socket_services.dart';
import 'package:get/get.dart';

class Binding implements Bindings{
  @override
  void dependencies() {
Get.put<AuthServices>(AuthServices());
Get.put<SocketServices>(SocketServices());
Get.lazyPut<PhoneController>(() => PhoneController(),fenix: true);
Get.lazyPut<ChatServices>(() =>ChatServices(),fenix: true);
Get.lazyPut<MessageServices>(() => MessageServices(),fenix: true);
Get.lazyPut<StoryServices>(() => StoryServices(),fenix: true);
  }


  
}