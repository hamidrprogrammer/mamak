import 'package:get/get.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';

class SplashViewModel extends BaseViewModel {
  final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();

  SplashViewModel(super.initialState){
    initSplash();
  }

  void initSplash() {
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      if(Get.isDialogOpen == true){
        return;
      }
      if (await loggedIn) {
        _navigationServiceImpl.off(AppRoute.home);
      } else {
        _navigationServiceImpl.off(AppRoute.register);
      }
    });
  }

  Future<bool> get loggedIn async =>
      await session.getData(UserSessionConst.mobile) != '';
}
