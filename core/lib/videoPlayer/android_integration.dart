import 'dart:convert';

import 'package:core/share/ShareFile.dart';

Future<String> getVideoFromContent(String content){
  return AndroidIntegration().getVideoPathFromContent(content);
}

class AndroidIntegration{
  Future<String> getVideoPathFromContent(String content){
    return ShareFile.saveVideoFile(base64Decode(content));
  }
}