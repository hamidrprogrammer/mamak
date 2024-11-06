

import 'package:mamak/core/network/errorHandler/ErrorModel.dart';
import 'package:mamak/presentation/state/app_state.dart';


extension NetworkExtensions on AppState {
  bool get isLoading => this is Loading;

  bool get isSuccess => this is Success;

  bool get isFailed => this is Error;

  dynamic get getData => isSuccess ? (this as Success).successData : null;
  ErrorModel? get getErrorModel => isFailed ? (this as Error).errorModel : null;
}
