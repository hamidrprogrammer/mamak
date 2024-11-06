import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamak/config/uiCommon/WidgetSize.dart';
import 'package:mamak/presentation/state/NetworkExtensions.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/MamakLogo.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/PasswordFieldHelper.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/ui/register/RegisterUi.dart';
import 'package:mamak/presentation/viewModel/user/RecoveryPasswordViewModel.dart';

class RecoveryPasswordUi extends StatelessWidget {
  const RecoveryPasswordUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (context) => RecoveryPasswordViewModel(AppState.idle),
      builder: (bloc, state) {
        return Padding(
          padding: const EdgeInsets.all(WidgetSize.pagePaddingSize),
          child: Form(
            key: bloc.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                20.dpv,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [MamakLogo(width: 150)],
                ),
                20.dpv,
                Text(
                  'change_password'.tr,
                  style: context.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                20.dpv,
                FormTitleWithStar(
                  title: "new_password".tr,
                ),
                4.dpv,
                PasswordFieldHelper(onChangeValue: bloc.onPasswordChange),
                10.dpv,
                FormTitleWithStar(
                  title: "confirm_new_pas".tr,
                ),
                4.dpv,
                PasswordFieldHelper(
                    onChangeValue: bloc.onConfirmPasswordChange),
                20.dpv,
                ElevatedButton(
                    onPressed: bloc.onSubmitClick,
                    child: bloc.state.isLoading
                        ? const MyLoader(color: Colors.black)
                        : Text('submit'.tr))
              ],
            ),
          ),
        );
      },
    );
  }
}
