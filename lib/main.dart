import 'package:chat_app/Bindings/Binding.dart';
import 'package:chat_app/BoxDatabase/ObjectBox.dart';
import 'package:chat_app/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'AuthScreen.dart';

late ObjectBox objectBox;
late IO.Socket socket;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   objectBox=await ObjectBox.create();
connecttoSocket();
  runApp(const MyApp());
}

connecttoSocket()async{
  String url=await Constants().detectDevice();
  
 socket=IO.io(url.substring(0,url.length-4),<String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "forceNew": true
    });
    socket.connect();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
    
      home:const AuthScreen(),
    );
  }
}



