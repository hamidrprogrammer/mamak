import 'package:core/Notification/MyNotification.dart';
import 'package:core/Notification/MyNotificationListener.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';
import 'package:mamak/presentation/uiModel/workBook/WorkBookParamsModel.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/workBook/GetParticipatedWorkShopsOfChildUserUseCase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetParticipatedWorkShopsOfChildUserViewModel extends BaseViewModel
    implements MyNotificationListener {
  final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();
  final MyNotification _notification = GetIt.I.get();
  WorkBookParamsModel model = WorkBookParamsModel();
  late ChildsItem selectedChild;

  GetParticipatedWorkShopsOfChildUserViewModel(super.initialState) {
    _notification.subscribeListener(this);
    SharedPreferences.getInstance().then((prefs) {
      String? value = prefs.getString('savedData');
      String? jsonString = prefs.getString('child_item');
      if (jsonString != null) {
        List<ChildsItem> items = childsItemFromJson(jsonString);
        getWorkBooks(items.first!.id.toString());
      }
    });

    getExtra();
  }

  void getWorkBooks(String userChildId) {
    print("userChildIdH");
    print(userChildId);
    model.userChildId = userChildId;
    GetParticipatedWorkShopsOfChildUserUseCase().invoke(
      mainFlow,
      data: userChildId,
    );
  }

  void getExtra() {
    String? userChildId = _navigationServiceImpl.getArgs();
    if (userChildId != null) {
      getWorkBooks(userChildId);
    }
  }

  gotoDetailView(num? id, {num? lastId, String? lastAgeDomain}) {
    if (id != null) {
      model.workShopId = id.toString();
      model.lastWorkShopId = lastId?.toString();
      model.lastAgeDomain = lastAgeDomain?.toString();
      _navigationServiceImpl.navigateTo(AppRoute.workBookDetail, model);
    }
  }

  @override
  void onReceiveData(data) {
    print("===========sdsadsadasdsa");
    print(data);
    if (data != null) {
      if (data is ChildsItem) {
        selectedChild = data;
        model.userChildId = (data).id.toString();
        getWorkBooks((data).id.toString());
      }
    }
  }

  @override
  String tag() {
    return 'GetParticipatedWorkShopsOfChildUserViewModel';
  }

  @override
  Future<void> close() {
    _notification.removeSubscribe(this);
    return super.close();
  }
}
