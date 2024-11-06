import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


saveFile(Uint8List bytes) async{
  var path = await ShareFile.saveFile(bytes);
  ShareFile.openFile(path);
}

class ShareFile {


}
