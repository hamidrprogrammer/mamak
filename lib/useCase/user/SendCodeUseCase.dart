import 'package:mamak/config/apiRoute/user/UserUrls.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class SendCodeUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    assert(data != null && data is String);
    try {
      flow.emitLoading();
      var uri = createUri(path: UserUrls.forgetPsw);
      var response =
          await apiServiceImpl.post(uri, data: jsonEncode({'Username': data}));
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
