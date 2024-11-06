import 'package:mamak/config/apiRoute/home/HomeUrls.dart';
import 'package:mamak/data/serializer/home/HomeResponse.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class HomeUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    try {
      flow.emitLoading();
      var uri = UriCreator.createUriWithUrl(
          url: 'mamakschool.ir', path: '/api${HomeUrls.home}');
      var response = await apiServiceImpl.get(uri);
      if (response.isSuccessful) {
        var homeResponse = homeResponseFromJson(response.body);
        flow.emitData(homeResponse);
      } else {
        flow.throwError(response);
      }
    } catch (e) {
      flow.throwCatch(e);
    }
  }
}
