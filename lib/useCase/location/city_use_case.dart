import 'package:mamak/config/apiRoute/location/location_urls.dart';
import 'package:mamak/data/serializer/location/CityItem.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class CityUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    assert(data != null && data is String);
    var uri = createUri(
        path: LocationUrls.getCitiesOfProvince, body: {'provinceId': data});
    try {
      flow.emitLoading();
      var response = await apiServiceImpl.get(uri);
      if (response.isSuccessful) {
        var result = response.result;
        if (result.isSuccessFull) {
          flow.emitData(cityItemsFromJson(result.result));
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
