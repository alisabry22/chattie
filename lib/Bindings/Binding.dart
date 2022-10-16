import 'package:chat_app/Services/AuthServices/AuthServices.dart';
import 'package:chat_app/Services/PhoneServices/phoneController.dart';
import 'package:get/get.dart';

class Binding implements Bindings{
  @override
  void dependencies() {
Get.put<AuthServices>(AuthServices());
Get.lazyPut<phoneController>(() => phoneController(),fenix: true);
  }


  
}