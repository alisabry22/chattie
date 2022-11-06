import 'package:chat_app/Bindings/bindings.dart';
import 'package:chat_app/BoxDatabase/object_box.dart';
import 'package:chat_app/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';


late ObjectBox objectBox;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   objectBox=await ObjectBox.create();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
    
      home: AuthScreen(),
    );
  }
}



