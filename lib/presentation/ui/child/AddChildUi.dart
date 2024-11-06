import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mamak/core/form/validator/LastNameValidator.dart';
import 'package:mamak/core/form/validator/NameValidator.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/DropDownFormField.dart';
import 'package:mamak/presentation/ui/main/MamakScaffold.dart';
import 'package:mamak/presentation/ui/main/MamakTitle.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/TextFormFieldHelper.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/ui/register/RegisterUi.dart';
import 'package:mamak/presentation/ui/root/MainPageUI.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/presentation/viewModel/child/AddChildViewModel.dart';
import 'package:mamak/presentation/viewModel/user/ProfileViewModel.dart';
import 'package:shamsi_date/shamsi_date.dart';

class AddChildUi extends StatelessWidget {
  const AddChildUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (context) => AddChildViewModel(AppState.idle),
      builder: (bloc, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Stack(
              children: [
                Positioned.fill(
                  top: 15,
                  child: Image.asset(
                    'assets/Rectangle21.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                AppBar(
                  title: Text(
                    "add_child".tr,
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: bloc.formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextInputField("child_name".tr, "enter_child_name".tr,
                        bloc.onChildFirstNameChange),
                    SizedBox(height: 12),
                    buildTextInputField("child_lastname".tr,
                        "enter_child_lastname".tr, bloc.onChildLastNameChange),
                    SizedBox(height: 12),
                    // Text(
                    //   "gender".tr,
                    //   style: TextStyle(
                    //     fontFamily: 'IRANSansXFaNum',
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 14,
                    //     color: Color(0xFF353842),
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     buildGenderRadioButton("female".tr),
                    //     SizedBox(width: 50),
                    //     buildGenderRadioButton("male".tr),
                    //   ],
                    // ),
                    SizedBox(height: 12),
                    Text(
                      'birthdate'.tr,
                      style: TextStyle(
                        fontFamily: 'IRANSansXFaNum',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff353842),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Color(0xfff6f6f8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropDownFormField(
                              selectedItem: DropDownModel(data: 10, name: "10"),
                              items: positiveIntegers
                                  .skip(1)
                                  .take(31)
                                  .toList()
                                  .map((e) => DropDownModel(
                                      data: e, name: e.toString()))
                                  .toList(),
                              name: 'day'.tr,
                              onValueChange: bloc.onDayChange,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Color(0xfff6f6f8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropDownFormField(
                              selectedItem: DropDownModel(data: 2, name: "2"),
                              items: positiveIntegers
                                  .skip(1)
                                  .take(12)
                                  .toList()
                                  .map((e) => DropDownModel(
                                      data: e, name: e.toString()))
                                  .toList(),
                              name: 'month'.tr,
                              onValueChange: bloc.onMonthChange,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 130,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Color(0xfff6f6f8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropDownFormField(
                              selectedItem: DropDownModel(
                                  data: Get.locale == const Locale('fa', 'IR')
                                      ? 1397
                                      : 2017,
                                  name: "1398"),
                              items: positiveIntegers
                                  .skip(Get.locale == const Locale('fa', 'IR')
                                      ? 1397
                                      : 2018)
                                  .take(6)
                                  .toList()
                                  .map((e) => DropDownModel(
                                      data: e, name: e.toString()))
                                  .toList(),
                              name: 'year'.tr,
                              onValueChange: bloc.onYearChange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'child_picture_optional'.tr,
                      style: TextStyle(
                        fontFamily: 'IRANSansXFaNum',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff353842),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        bloc.addImage();
                        // Handle image upload
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (bloc.selectedImage != null)
                            ClipOval(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.memory(
                                  bloc.selectedImage!.getFileFormBase642(),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          if (bloc.selectedImage == null)
                            Image.asset('assets/edit.png',
                                width: 100, height: 100)
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          bloc.getUseData();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(16.0),
                        ),
                        child: Center(
                          child: Text(
                            "submit_child".tr,
                            style: TextStyle(
                              fontFamily: 'IRANSansXFaNum',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPageUI()),
                            (Route<dynamic> route) =>
                                false, // Remove all routes from the stack
                          );
                        },
                        child: Text(
                          "add_later".tr,
                          style: TextStyle(
                            fontFamily: 'IRANSansXFaNum',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xFF9E3840),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget _buildImageUpload(Function onPress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'optional_image'.tr,
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff353842),
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            onPress();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/edit.png', width: 100, height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextInputField(
      String title, String placeholder, Function(String) onChangeValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF353842),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Color(0xFFF6F6F8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            textAlign: TextAlign.right,
            onChanged: onChangeValue,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xff505463),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGenderRadioButton(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff353842),
          ),
        ),
        Radio(
          value: true,
          groupValue: true,
          onChanged: (bool? value) {},
        ),
      ],
    );
  }
}

Iterable<int> get positiveIntegers sync* {
  int i = 0;
  while (true) {
    yield i++;
  }
}
