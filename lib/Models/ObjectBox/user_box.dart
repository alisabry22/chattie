import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()

class UserBox{

int id;
String username,email,phone,countrycode,userID,quote;
List<String>phones;
@Property(type: PropertyType.byteVector)
Uint8List personalphoto;

UserBox({
  this.id=0,
  required this.username,
  required this.email,
  required this.phone,
  required this.countrycode,
  required this.phones,
  required this.userID,
  required this.personalphoto,
  required this.quote,
   
});

  
}