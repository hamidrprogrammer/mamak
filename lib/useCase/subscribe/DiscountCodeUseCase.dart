import 'package:mamak/config/apiRoute/subscribe/SubscribeUrls.dart';
import 'package:mamak/data/body/subscribe/DiscountCodeBody.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class DiscountCodeUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    assert(data != null && data is DiscountCodeBody);

    try {
      flow.emitLoading();

      var uri = createUri(
          path: SubscribeUrls.calulatePriceInCart,
          body: (data as DiscountCodeBody).toJson());

      var response = await apiServiceImpl.get(uri);

      if (response.isSuccessful) {
        var result = response.result;

        if (result.isSuccessFull) {
          flow.emitData(result.result);
        } else {
          flow.throwMessage(result.concatErrorMessages);
        }
      } else {
        flow.throwError(response);
      }
    } catch (e) {
      Logger.e(e);
      flow.throwCatch(e);
    }
  }
}
