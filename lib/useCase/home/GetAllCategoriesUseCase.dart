import 'package:mamak/config/apiRoute/home/HomeUrls.dart';
import 'package:mamak/data/serializer/home/CategoryResponse.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class GetAllCategoriesUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    try {
      flow.emitLoading();

      var uri = createUri(path: HomeUrls.category);
      var response = await apiServiceImpl.get(uri);
      if (response.isSuccessful) {
        var result = response.result;
        if (result.isSuccessFull) {
          flow.emitData(categoryFromJson(result.resultsList));
        } else {
          flow.throwMessage(result.concatErrorMessages);
        }
      } else {
        flow.throwError(response);
      }
    } catch (e) {
      Logger.e('category error is $e');
      flow.throwCatch(e);
    }
  }
}
