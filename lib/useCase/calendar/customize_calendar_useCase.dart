import 'package:mamak/config/apiRoute/calendar/calendar_urls.dart';
import 'package:mamak/data/body/calendar/UserCustomCalendarBody.dart';
import 'package:mamak/useCase/BaseUseCase.dart';

class CustomizeCalendarUseCase extends BaseUseCase {
  @override
  void invoke(MyFlow<AppState> flow, {Object? data}) async {
    assert(data != null && data is UserCustomCalendarBody);
    flow.emitLoading();
    try {
      var uri =
          createUri(path: CalendarUrls.postSetCustomizedUserChildCalendar);
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
