import 'package:chat_app/Bindings/Binding.dart';
import 'package:chat_app/BoxDatabase/ObjectBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'AuthScreen.dart';

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



