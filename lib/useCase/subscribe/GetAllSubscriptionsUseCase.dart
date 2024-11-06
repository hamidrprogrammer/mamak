import 'package:mamak/config/apiRoute/subscribe/SubscribeUrls.dart';
import 'package:mamak/data/serializer/subscribe/AllSubscriptionResponse.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class GetAllSubscriptionsUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    try {
      flow.emitLoading();
      var uri = createUri(path: SubscribeUrls.getAllSubscriptions);
      var response = await apiServiceImpl.get(uri);

      if (response.isSuccessful) {
        var result = response.result;
        if (result.isSuccessFull) {
          flow.emitData(allSubscriptionItemFromJson(result.resultsList));
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
