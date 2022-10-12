

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
class Constants{
  String url="";
  DeviceInfoPlugin deviceinfo=DeviceInfoPlugin();
  
 Future<String> detectDevice()async{
  if(Platform.isAndroid){
    var androidinfo=await deviceinfo.androidInfo;

    if(androidinfo.isPhysicalDevice!=null ){
     bool? physicaldevice=androidinfo.isPhysicalDevice;
     if(physicaldevice==true)
      return url="http://192.168.2.22:3000/api";
      else
      return url="http://10.0.2.2:3000/api";
    }
    return url="http://10.0.2.2:3000/api";
  }
  return url="http://10.0.2.2:3000/api";


  }
 
 
}