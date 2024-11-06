import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/home/GetPackagesDetailUseCase.dart';

class PackageDetailViewModel extends BaseViewModel{
  PackageDetailViewModel(super.initialState){
    getExtra();
  }
  String? id;
  final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();


  void getExtra(){
    id = _navigationServiceImpl.getArgs();
    if(id != null && id is String){
      GetPackagesDetailUseCase().invoke(mainFlow,data: id);
    }
  }



}