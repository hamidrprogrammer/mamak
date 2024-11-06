import 'package:core/dioNetwork/interceptor/AuthorizationInterceptor.dart';
import 'package:flutter/material.dart';
import 'package:mamak/data/serializer/user/User.dart';
import 'package:mamak/presentation/state/formState/user/LoginFormState.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/user/LoginUseCase.dart';
import 'package:mamak/useCase/user/SendVerificationCodeUseCase.dart';
import 'package:rxdart/rxdart.dart';

class LoginViewModel extends BaseViewModel {
  var navigationService = GetIt.I.get<NavigationServiceImpl>();
  var formKey = GlobalKey<FormState>();
  var loginFormState = BehaviorSubject<LoginFormState>();
  late final loginUseCase =
      LoginUseCase.initFormState(loginFormState: loginFormState.value);

  LoginViewModel(super.initialState) {
    loginFormState.value = LoginFormState();
    // getExtra();
  }

  // void getExtra() {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
  //   Logger.d('getting extra');
  //   var modal = Get.arguments;
  //   Logger.d(modal.toString());
  //   if (modal is User && modal.mobile != null) {
  //     Logger.d(modal.mobile.toString());
  //     loginFormState.value.mobile = modal.mobile!;
  //   }
  // }

  bool get isValid => formKey.currentState?.validate() == true;

  Function(String) get onMobileChange =>
      (value) => loginFormState.value.username = value;

  Function(String) get onPasswordChange =>
      (value) => loginFormState.value.password = value;

  Function() loginUser() {
    return () {
      // if (isValid) {
      loginUseCase.invoke(
        MyFlow(flow: (state) async {
          postResult(state);
          if (state.isSuccess) {
            if (state.getData is User) {
              var user = state.getData as User;
              if (user.isActive == true) {
                await saveUserData(user);
                navigationService.replaceTo(AppRoute.home);
              } else {
                SendVerificationUseCase()
                    .invoke(MyFlow(flow: (_) {}), data: user.id?.toString());
                navigationService.replaceTo(AppRoute.verification, {
                  'email': loginFormState.value.username,
                  'id': user.id?.toString()
                });
              }
            } else if (state.getData is String) {
              SendVerificationUseCase()
                  .invoke(MyFlow(flow: (_) {}), data: state.getData.toString());
              navigationService.replaceTo(AppRoute.verification, {
                'email': loginFormState.value.username,
                'id': state.getData.toString()
              });
            }
          } else if (state.isFailed) {
            messageService.showSnackBar(state.getErrorModel?.message ?? '');
          }
        }),
      );
      // }
    };
  }

  Function() gotoSignUpPage() => () {
        navigationService.replaceTo(AppRoute.register);
      };

  Future<bool> saveUserData(User user) {
    GetIt.I.get<AuthorizationInterceptor>().setToken(user.token ?? '');
    GetIt.I
        .get<AuthorizationInterceptor>()
        .setrefreshToken(user.refreshToken ?? '');
    var map = {
      UserSessionConst.token: '${user.token}',
      UserSessionConst.fullName: '${user.fullName}',
      UserSessionConst.mobile: user.mobile ?? '',
      UserSessionConst.email: user.email ?? '',
      UserSessionConst.image: user.avatar?.content ?? '',
    };
    session.insertData(map);
    return Future.value(true);
  }

  Function() pushToRegister() =>
      () => navigationService.replaceTo(AppRoute.register);

  Function() pushToForgetPassword() =>
      () => navigationService.navigateTo(AppRoute.forgetPassword);

  Function() pushToVerificationPage(User user) =>
      () => navigationService.replaceTo(AppRoute.register, user);
}
