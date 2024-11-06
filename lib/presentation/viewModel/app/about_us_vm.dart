import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/app/about_UseCase.dart';

class AboutUsViewModel extends BaseViewModel {
  AboutUsViewModel(super.initialState) {
    getAboutUsData();
  }

  getAboutUsData() {
    AboutUseCase().invoke(mainFlow);
  }
}
