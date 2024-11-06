import 'dart:convert';
import 'dart:typed_data';

import 'package:feature/navigation/NavigationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mamak/config/appData/route/AppRoute.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';
import 'package:mamak/presentation/state/NetworkExtensions.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/child/AddChildUi.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/viewModel/child/AddChildViewModel.dart';

import 'package:mamak/presentation/ui/main/DropDownFormField.dart';

class EditChildPage extends StatelessWidget {
  const EditChildPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();
    final ChildsItem? packageId = Get.arguments as ChildsItem;
    DateTime? birthDate = packageId?.birtDate;
    int birthDay = birthDate!.day; // 25
    int birthMonth = birthDate.month; // 10
    int birthYear = birthDate.year; // 2018
    Uint8List bytes = base64Decode(packageId?.childPicture?.content ?? '');

    return CubitProvider(
        create: (context) => AddChildViewModel(AppState.idle),
        builder: (bloc, state) {
          bloc.submitEditInit(packageId!);
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Stack(
                children: [
                  Positioned.fill(
                    top: kIsWeb ? 0 : 15,
                    child: Image.asset(
                      'assets/Rectangle21.png', // Path to your SVG file
                      fit: BoxFit.fitWidth,
                      // To cover the entire AppBar
                    ),
                  ),
                  AppBar(
                    title: Text(
                      'edit_child'.tr,
                      style: TextStyle(
                        fontFamily: 'IRANSansXFaNum',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    iconTheme: IconThemeData(color: Colors.white),
                    backgroundColor:
                        Colors.transparent, // Make AppBar transparent
                    elevation: 0, // Remove shadow
                  ),
                ],
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextInputField(
                        title: 'child_first_name'.tr,
                        hintText: '${packageId?.childFirstName}',
                        onChangeValue: bloc.onChildFirstNameChange,
                      ),
                      SizedBox(height: 16),
                      _buildTextInputField(
                        title: 'child_last_name'.tr,
                        hintText: '${packageId?.childLastName}',
                        onChangeValue: bloc.onChildLastNameChange,
                      ),
                      SizedBox(height: 16),
                      // _buildGenderSelection(),
                      SizedBox(height: 16),
                      // Text(
                      //   'birth_date'.tr,
                      //   style: TextStyle(
                      //     fontFamily: 'IRANSansXFaNum',
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 14,
                      //     color: Color(0xff353842),
                      //   ),
                      // ),
                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'child_picture_optional'.tr,
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
                                        bloc.selectedImage!
                                            .getFileFormBase642(),
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
                        ],
                      ),
                      SizedBox(height: 30),
                      _buildSubmitButton(() {
                        bloc.submitEdit(packageId!);
                      }, bloc.uiState.isLoading),
                      SizedBox(height: 16),
                      // _buildDeleteChildButton(),
                    ],
                  ),
                )),
          );
        });
  }

  Widget _buildTextInputField(
      {required String title,
      required String hintText,
      required Function(String) onChangeValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff353842),
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xfff6f6f8),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TextField(
            onChanged: onChangeValue,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
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

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'gender'.tr,
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xff353842),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(value: 1, groupValue: 2, onChanged: (value) {}),
                Text(
                  'boy'.tr,
                  style: TextStyle(
                    fontFamily: 'IRANSansXFaNum',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff505463),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio(value: 2, groupValue: 1, onChanged: (value) {}),
                Text(
                  'girl'.tr,
                  style: TextStyle(
                    fontFamily: 'IRANSansXFaNum',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xff505463),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(Function onPress, bool isLoading) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ElevatedButton(
          onPressed: () {
            onPress();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(16.0),
          ),
          child: Center(
            child: isLoading
                ? MyLoader()
                : Text(
                    'save_changes'.tr,
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
    );
  }

  Widget _buildDeleteChildButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Handle delete action
        },
        child: Text(
          'delete_child'.tr,
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xff505463),
          ),
        ),
      ),
    );
  }
}
