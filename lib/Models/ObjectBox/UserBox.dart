import 'package:objectbox/objectbox.dart';

@Entity()

class UserBox{

int id;
String username,email,phone,countrycode,userID;
List<String>phones;

UserBox({
  this.id=0,
  required this.username,
  required this.email,
  required this.phone,
  required this.countrycode,
  required this.phones,
  required this.userID,
   
});

  
}