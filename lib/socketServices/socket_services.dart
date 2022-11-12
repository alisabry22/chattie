import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketServices extends GetxController{
  
  IO.Socket socket=IO.io("http://192.168.1.3:3000",<String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "forceNew": true
    });
 
@override
  void onInit() {
    print(socket.connected);
     connecttoSocket();
   
    super.onInit();
   

  }


void connecttoSocket()async{


    socket.connect();
    print(socket.connected);
}
}