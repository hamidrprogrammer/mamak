import 'package:mamak/config/apiRoute/child/ChildUrls.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class AddSuitableWorkShopUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    assert(data != null && data is int);
    try {
      var uri = createUri(path: ChildUrls.postAddSuitableWorkShopsToUserChild);
      KanoonHttpResponse response = await apiServiceImpl.post(uri,
          data: jsonEncode({'userChildId': data}));
      if (response.isSuccessful) {
        var result = response.result;
        if (result.isSuccessFull) {
          flow.emitData('');
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
