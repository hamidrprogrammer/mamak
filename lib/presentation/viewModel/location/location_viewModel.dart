import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/location/provinces_use_case.dart';

class LocationViewModel extends BaseViewModel {
  LocationViewModel(super.initialState);

  AppState pState = AppState.idle;

  void fetchProvinces() {
    ProvinceUseCase().invoke(MyFlow(flow: (appState) {
      pState = appState;
      refresh();
    }));
  }
}
