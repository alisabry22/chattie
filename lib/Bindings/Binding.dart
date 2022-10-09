import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/socketServices/SocketServices.dart';
import 'package:get/get.dart';

class Binding implements Bindings{
  @override
  void dependencies() {
Get.put<AuthServices>(AuthServices());
Get.put<SocketServices>(SocketServices());
  }


  
}