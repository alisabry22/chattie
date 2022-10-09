import 'package:chat_app/Bindings/Binding.dart';
import 'package:chat_app/BoxDatabase/ObjectBox.dart';
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
 socket=IO.io("http://192.168.1.3:3000",<String, dynamic>{
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



