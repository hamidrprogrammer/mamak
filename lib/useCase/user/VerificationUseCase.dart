import 'package:mamak/config/apiRoute/user/UserUrls.dart';
import 'package:mamak/data/body/user/verification/VerificationBody.dart';
import 'package:mamak/data/serializer/user/User.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class VerificationUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    assert(data != null && data is VerificationBody,
        'data for VerificationUseCase must be valid and not null!');

    try {
      flow.emitLoading();

      var uri = createUri(path: UserUrls.verification);

      var response = await apiServiceImpl.post(uri, data: jsonEncode(data));
      if (response.isSuccessful) {
        var result = response.result;
        if (result.isSuccessFull) {
          flow.emitData(userFromJson(result.result ?? ''));
        } else {
          flow.throwMessage(result.concatErrorMessages);
        }
      } else {
        flow.throwError(response);
      }
    } catch (e) {
      flow.throwCatch(e);
    }
  }
}
