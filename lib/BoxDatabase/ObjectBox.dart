import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:chat_app/Models/ObjectBox/UserBox.dart';
import 'package:chat_app/objectbox.g.dart';

class ObjectBox{
  late final Store store;
  late final Box<UserBox>userBox;
  
ObjectBox._create(this.store){
  userBox=Box<UserBox>(store);
  }
  static Future <ObjectBox>create()async{
    final docsdir=await getApplicationDocumentsDirectory();

    final store=await openStore(directory:p.join(docsdir.path,"objectbox") );
    
    return ObjectBox._create(store);
  }
}