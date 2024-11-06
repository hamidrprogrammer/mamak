import 'package:feature/poolakey/inapp_purchase_info.dart';
import 'package:flutter_poolakey/purchase_info.dart';

extension PurchaseExtension on PurchaseInfo {
  InAppPurchaseInfo get toInAppPurchaseInfo => InAppPurchaseInfo(
        productId: productId,
        packageName: packageName,
        state: purchaseState == PurchaseState.PURCHASED
            ? InAppPurchaseState.success
            : InAppPurchaseState.refund,
      );
}
