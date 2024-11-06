import 'package:feature/poolakey/inapp_purchase_info.dart';
import 'package:feature/poolakey/purchase_extension.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';

class PoolakeyHelper {
  final String rsa =
      'MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwCo74cdMXYEKd8+sUwy5vjsj4fL+7RP0v5MCI9r8hEwg9RvSJrp071LBBh8zTCp4/EwR2wsZiOVm0DZB7SJmyzDkNNWlT+j6QWlM6TePkCHQAhc7oZYvtpTZCdOavlwEB2Z8lzIVqL8jupYm4z0yl0CYDlFRn9ghlSDytRu52b/gBgg3iWV/hmgGQHsje9pVPQS6dZE2sLnVH+YMlvg+KuhbEBVnK5SgkoUnQOPhBECAwEAAQ==';

  PoolakeyHelper() {
    init();
  }

  void init() async {
    await FlutterPoolakey.connect(rsa, onDisconnected: () {
      /*reconnect here*/
      print('disconnected from cafebazaar');
    });
  }

  Future<InAppPurchaseInfo> purchase({required String pId,String token = ""}) async {
    return (await FlutterPoolakey.purchase(pId,dynamicPriceToken: token)).toInAppPurchaseInfo;
  }
}
