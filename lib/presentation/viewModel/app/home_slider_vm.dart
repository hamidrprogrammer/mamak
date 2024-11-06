import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/app/home_slider_UseCase.dart';

class HomeSliderViewModel extends BaseViewModel {
  HomeSliderViewModel(super.initialState) {
    HomeSliderUseCase().invoke(mainFlow);
  }
}
