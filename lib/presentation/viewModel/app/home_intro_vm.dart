import 'package:core/share/ShareFile.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/BaseUseCase.dart';
import 'package:mamak/useCase/app/home_intro_UseCase.dart';

class HomeIntroViewModel extends BaseViewModel {
  HomeIntroViewModel(super.initialState) {
    HomeIntroUseCase().invoke(mainFlow);
  }

  Future<String> getPath(String content) async {
    var path = await ShareFile.saveVideoFile(base64Decode(content));
    Logger.d('path is $path');
    return path;
  }
}
