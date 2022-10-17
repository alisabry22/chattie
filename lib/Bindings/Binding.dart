import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/Services/ChatServices/chatServices.dart';
import 'package:chat_app/Services/MessageServices/MessageServices.dart';
import 'package:chat_app/Services/PhoneServices/phoneController.dart';
import 'package:chat_app/Services/StoryServices/StoryServices.dart';
import 'package:chat_app/socketServices/socketservices.dart';
import 'package:get/get.dart';

class Binding implements Bindings{
  @override
  void dependencies() {
Get.put<AuthServices>(AuthServices());
Get.put<SocketServices>(SocketServices());
Get.lazyPut<phoneController>(() => phoneController(),fenix: true);
Get.lazyPut<ChatServices>(() =>ChatServices(),fenix: true);
Get.lazyPut<MessageServices>(() => MessageServices(),fenix: true);
Get.lazyPut<StoryServices>(() => StoryServices(),fenix: true);
  }


  
}