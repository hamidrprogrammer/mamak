import 'package:mamak/config/apiRoute/child/ChildUrls.dart';
import 'package:mamak/data/body/child/EditChildDataBody.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class EditChildDataUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    assert(data != null && data is EditChildDataBody);
    try {
      (data as EditChildDataBody).mobileNumber = await GetIt.I
          .get<LocalSessionImpl>()
          .getData(UserSessionConst.mobile);
      flow.emitLoading();
      var uri = createUri(path: ChildUrls.postEditChildOfParentUser);
      var response = await apiServiceImpl.post(uri, data: jsonEncode(data));

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
