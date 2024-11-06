import 'package:mamak/config/apiRoute/app/AppUrls.dart';
import 'package:mamak/data/serializer/home/about/about_us_response.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class AboutUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    try {
      flow.emitLoading();

      var uri = createUri(path: AppUrls.getAboutUs);

      var response = await apiServiceImpl.get(uri);

      if (response.isSuccessful) {
        var result = response.result;

        if (result.isSuccessFull) {
          var str = jsonDecode(result.result)['image']['content'];
          flow.emitData(str);
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
