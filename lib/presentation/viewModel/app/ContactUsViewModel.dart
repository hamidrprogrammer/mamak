import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mamak/data/serializer/app/ContactUsResponse.dart';
import 'package:mamak/presentation/state/formState/app/ContactUsFormState.dart';
import 'package:mamak/presentation/uiModel/app/ContactUsUiModel.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/useCase/app/ContactUsUseCase.dart';
import 'package:mamak/useCase/app/GetContactUsUseCase.dart';

class ContactUsViewModel extends BaseViewModel {
  ContactUsViewModel(super.initialState) {
    getData();
  }

  ContactUsUiModel contactUsData = ContactUsUiModel();
  final MapController mapController = MapController();

  AppState formUiState = AppState.idle;
  AppState dataState = AppState.idle;

  ContactUsFormState formState = ContactUsFormState();
  final formKey = GlobalKey<FormState>();

  onNameChange(String name) => formState.fullName = name;

  onEmailChange(String email) => formState.email = email;

  onMobileChange(String mobile) => formState.mobile = mobile;

  onSubChange(String sub) => formState.subject = sub;

  onTextChange(String text) => formState.message = text;

  void refresh() {
    updateScreen(time: DateTime.now().microsecondsSinceEpoch.toDouble());
  }

  void getData() {
    GetContactUsUseCase().invoke(MyFlow(flow: (appState) {
      if (appState.isSuccess && appState.getData is ContactUsResponse) {
        ContactUsResponse data = appState.getData;
        LatLng latLng = LatLng(
            double.tryParse(data.latitude?.toString() ?? '0') ?? 0.0,
            double.tryParse(data.longitude?.toString() ?? '0') ?? 0.0);

        mapController.move(latLng, 15.0);
        contactUsData = ContactUsUiModel(
          address: data.address ?? '',
          phone: data.tellNumber ?? '',
          latLng: latLng,
        );
      }
      dataState = appState;
      refresh();
    }));
  }

  void submitForm() {
    if (formState.subject == '') {
      messageService.showSnackBar('enter_subject'.tr);
      return;
    }
    if (formState.message == '') {
      messageService.showSnackBar('enter_text'.tr);
      return;
    }

    if (formKey.currentState?.validate() == true) {
      ContactUsUseCase().invoke(MyFlow(flow: (appState) {
        if (appState.isSuccess) {
          messageService.showSnackBar('success_sent'.tr);
        }

        formUiState = appState;
        refresh();
      }), data: formState.createBody());
    }
  }
}
