import 'package:chat_app/Constants/Constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServices extends GetxController{


 static late IO.Socket socket;


 static void connectSocket( ){
 
socket=IO.io("http://192.168.1.7:3000",<String,dynamic>{
  "transports":["websocket"],
  "autoConnect":false,
});
socket.connect();
   

        socket.on("connect", (data){
          print("connected $data");
          
    });


    
    //listen for incoming messages from server.
  
    socket.on("message", (data) {
      print("message event");
      print(data);  
    });
    socket.on("disconnect", (data) {
      print(data);
    });

}

 




 
  


 

  

}