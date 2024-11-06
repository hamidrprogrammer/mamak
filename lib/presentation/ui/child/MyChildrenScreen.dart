import 'dart:convert';
import 'dart:typed_data';

import 'package:feature/navigation/NavigationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mamak/config/appData/locales/AppDefaultLocale.dart';
import 'package:mamak/config/appData/route/AppRoute.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';
import 'package:mamak/di/appModule.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/main/ConditionalUI.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/presentation/viewModel/home/new_home_viewModel.dart';

class MyChildrenScreen extends StatelessWidget {
  const MyChildrenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();

    return Scaffold(
      backgroundColor: Color(0xFFF8F8FC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Positioned.fill(
              top: kIsWeb ? 0 : 15,
              child: Image.asset(
                'assets/Rectangle21.png', // Path to your SVG file
                fit: BoxFit.fitWidth,
              ),
            ),
            AppBar(
              title: Text(
                'My_children'.tr, // Localization
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
      body: CubitProvider(
        create: (context) => NewHomeViewModel(AppState.idle),
        builder: (blocW, state) {
          print("CubitProvider");
          print(state.toString());

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ConditionalUI<List<ChildsItem>>(
                    skeleton: Center(
                      child: MyLoaderBig(),
                    ),
                    state: blocW.childState,
                    onSuccess: (childs) {
                      print("childs");
                      print(childs.length);
                      return ListView.builder(
                        itemCount: childs.length,
                        itemBuilder: (context, index) {
                          var child = childs[index];
                          Uint8List bytes =
                              base64Decode(child?.childPicture?.content ?? '');

                          return SizedBox(
                            child: ChildCard(
                              childName:
                                  '${child.childFirstName} ${child.childLastName}\n ${child.childAge}',
                              imagePath: 'assets/group-60.svg',
                              bytes: bytes,
                              top: 66,
                              onPress: () {
                                Get.toNamed(
                                  AppRoute.eitChildPage,
                                  arguments: child,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onPressed: () {
                      _navigationServiceImpl.navigateTo(AppRoute.addChild);
                    },
                    child: Text(
                      'Add_new_child'.tr, // Localization
                      style: TextStyle(
                        fontFamily: 'IRANSansXFaNum',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChildCard extends StatelessWidget {
  final String childName;
  final String imagePath;
  final double top;
  final Function onPress;
  final Uint8List bytes;
  const ChildCard(
      {required this.childName,
      required this.imagePath,
      required this.top,
      required this.onPress,
      required this.bytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          bytes.length > 10
              ? ClipOval(
                  child: Image.memory(
                    bytes,
                    height: 32,
                    width: 32,
                  ),
                )
              : SvgPicture.asset(
                  imagePath,
                  height: 32,
                  width: 32,
                ),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              childName,
              style: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Color.fromARGB(255, 0, 6, 26),
              ),
              textAlign: AppDefaultLocale.getAppLocale.toString() == "en_US"
                  ? TextAlign.left
                  : TextAlign.right,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Color(0xFF9E3840)),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              ),
              onPressed: () {
                onPress();
              },
              child: Text(
                'Edit'.tr, // Localization
                style: TextStyle(
                  fontFamily: 'IRANSansXFaNum',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 2,
                  color: Color(0xFF9E3840),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
