import 'package:chat_app/Constants/Constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketServices extends GetxController{
  IO.Socket socket=IO.io("http://10.0.2.2:3000",<String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "forceNew": true
    });
 
@override
  void onInit() {
     connecttoSocket();
   
    super.onInit();
   

  }


void connecttoSocket()async{


    socket.connect();
    print(socket.connected);
}
}