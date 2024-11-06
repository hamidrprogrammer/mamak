import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

saveFile(Uint8List bytes) async{
  var path = await ShareFile.saveFile(bytes);
  ShareFile.openFile(path);
}

class ShareFile {
  static Future<ShareResult> shareFile(Uint8List bytes) {
    return Share.shareXFiles(
      [XFile.fromData(bytes, mimeType: 'application/pdf')],
      subject: 'انتخاب برای بازکردن فایل',
    );
  }

  static Future<String> saveFile(Uint8List bytes) async {
    var name = '${DateTime.now().microsecondsSinceEpoch}.pdf';
    var tempDir = await getExternalStorageDirectory();
    await XFile.fromData(bytes, mimeType: 'application/pdf', name: name)
        .saveTo('${tempDir?.path}/$name');
    return '${tempDir?.path}/$name';
  }

  static Future<String> saveVideoFile(Uint8List bytes) async {
    var name = '${DateTime.now().microsecondsSinceEpoch}.mp4';
    var tempDir = await getExternalStorageDirectory();
    await XFile.fromData(bytes, mimeType: 'video/mp4', name: name)
        .saveTo('${tempDir?.path}/$name');
    return '${tempDir?.path}/$name';
  }

  static void openFile(String filePath) {
    OpenFile.open(filePath);
  }
}
