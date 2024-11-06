import 'dart:convert';

import 'package:core/dioNetwork/interceptor/culture_interceptor.dart';
import 'package:core/imagePicker/ImageFileModel.dart';
import 'package:core/imagePicker/MyImagePicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mamak/config/uiCommon/WidgetSize.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';
import 'package:mamak/data/serializer/user/GetUserProfileResponse.dart';
import 'package:mamak/presentation/ui/login/LoginUi.dart';
import 'package:mamak/presentation/ui/main/ConditionalUI.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/viewModel/baseViewModel.dart';
import 'package:mamak/presentation/viewModel/child/GetChildsViewModel.dart';
import 'package:mamak/presentation/viewModel/user/ProfileViewModel.dart';
import 'package:mamak/useCase/app/set_culture_use_case.dart';
import 'package:mamak/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ProfileUi extends StatefulWidget {
  const ProfileUi({Key? key}) : super(key: key);
  @override
  _ProfileUiState createState() => _ProfileUiState();
}

class _ProfileUiState extends State<ProfileUi> {
  bool _isLoading = false; // Loading state

  Widget _buildListItem(
      String assetPath, String title, final Function() onSelectChild,
      {bool isLogout = false,
      bool disable = false,
      Color logoutColor = Colors.black}) {
    return Opacity(
      opacity: disable ? 0.3 : 1, // Set the desired opacity here
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: -2.0),
        leading: SvgPicture.asset(
          assetPath,
          width: 20.0, // Adjust size as needed
          height: 20.0, // Adjust size as needed
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12.0,
            color: isLogout ? logoutColor : Color(0xFF353842),
          ),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 8.0, color: Color(0xFF353842)),
        onTap: () {
          if (!disable) {
            onSelectChild();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();
    logoutClick() {
      Get.dialog(const LogoutDialog());
    }

    changePasswordClick() {
      _navigationServiceImpl.navigateTo(AppRoute.changePassword);
    }

    contactUsApp() {
      _navigationServiceImpl.navigateTo(AppRoute.contactUsApp);
    }

    mChildrenScreenClick() {
      _navigationServiceImpl.navigateTo(AppRoute.myChildren);
    }

    transactionsScreen() {
      _navigationServiceImpl.navigateTo(AppRoute.transactionsScreen);
    }

    addChildClick() {
      _navigationServiceImpl.navigateTo(AppRoute.addChild);
    }

    CalendarScreen() {
      _navigationServiceImpl.navigateTo(AppRoute.calendarScreen);
    }

    sourceClick() {
      _navigationServiceImpl.navigateTo(AppRoute.sourceClick);
    }

    informationClick() {
      _navigationServiceImpl.navigateTo(AppRoute.information);
    }

    subscriptionClick() {
      _navigationServiceImpl.navigateTo(AppRoute.subscription);
    }

    void makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );

      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        throw 'Could not launch $launchUri';
      }
    }

    void resetApp() {
      // You can either navigate to your main page or reinitialize state here
      // Example of navigating to home page (ensure the route exists)
      Get.offAllNamed('/home'); // or replace '/home' with your main route

      // Alternatively, if you want to clear the navigation stack
      // Get.offAll(() => HomePage()); // Replace with your main widget
    }

    final MyImagePicker _myImagePicker = GetIt.I.get();

    var avatarId = '00000000-0000-0000-0000-000000000000';
    langsClick() async {
      setState(() {
        _isLoading = true;
      });
      Get.updateLocale(Locale('en', 'US'));
      GetIt.I
          .get<LocalSessionImpl>()
          .insertData({UserSessionConst.lang: 'English'});
      SetCultureUseCase().invoke(MyFlow(flow: (state) {}), data: 'en-US');
      GetIt.I.get<CultureInterceptor>().setCulture('en-US');
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    }

    langsClickFa() async {
      setState(() {
        _isLoading = true;
      });
      GetIt.I
          .get<LocalSessionImpl>()
          .insertData({UserSessionConst.lang: 'Persian'});
      SetCultureUseCase().invoke(MyFlow(flow: (state) {}), data: 'fa-IR');
      GetIt.I.get<CultureInterceptor>().setCulture('fa-IR');
      Get.updateLocale(Locale('fa', 'IR'));
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    }

    return WillPopScope(
        onWillPop: () async {
          // Return false to prevent back navigation
          return false;
        },
        child: CubitProvider(
          create: (context) => ProfileViewModel(AppState.idle),
          builder: (bloc, state) {
            return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: 15,
                        child: Image.asset(
                          'assets/Rectangle21.png', // Path to your SVG file
                          fit: BoxFit.fitWidth,
                          // To cover the entire AppBar
                        ),
                      ),
                      AppBar(
                        title: Text(
                          'dashboard'.tr,
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
                body: Container(
                  color: Color(0xFFF8F8FC),
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isLoading)
                              Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                  color: Color.fromARGB(255, 246, 5, 121),
                                  size: 45,
                                ),
                              ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     InkWell(
                            //       onTap: langsClickFa,
                            //       child: SizedBox(
                            //         width: 50, // Set the desired width
                            //         height: 70, // Set the desired height
                            //         child: Column(
                            //           children: [
                            //             Image.asset(
                            //               'assets/iran.png',
                            //               width: 20,
                            //             ),
                            //             SizedBox(height: 10),
                            //             Text(
                            //               'فارسی',
                            //               style: TextStyle(
                            //                 fontSize: 10.0,
                            //                 color: Color(0xFF696F82),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(width: 8),
                            //     InkWell(
                            //         onTap: langsClick,
                            //         child: SizedBox(
                            //           width: 50, // Set the desired width
                            //           height: 70, // Set the desired height
                            //           child: Column(
                            //             children: [
                            //               SvgPicture.asset(
                            //                 'assets/england.svg',
                            //                 width: 20,
                            //               ),
                            //               SizedBox(height: 10),
                            //               Text(
                            //                 'English',
                            //                 style: TextStyle(
                            //                   fontSize: 10.0,
                            //                   color: Color(0xFF696F82),
                            //                 ),
                            //               )
                            //             ],
                            //           ),
                            //         )),
                            //   ],
                            // ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                FutureBuilder(
                                  future: bloc.getUserImage,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data is String &&
                                        snapshot.data != '') {
                                      return CircleAvatar(
                                        radius: 27.0,
                                        backgroundColor: Colors
                                            .transparent, // Set transparent background
                                        child: ClipOval(
                                          child: Image.memory(
                                            base64Decode(
                                                snapshot.data.toString()),
                                            width:
                                                54.0, // Adjust size as needed
                                            height:
                                                54.0, // Adjust size as needed
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }
                                    return ClipOval(
                                      child: Image.asset(
                                        'assets/avatar.jpg',
                                        width: 54.0, // Adjust size as needed
                                        height: 54.0, // Adjust size as needed
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),

                                SizedBox(width: 16.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'username'.tr,
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Color(0xFF696F82),
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: bloc.getUserFullName,
                                      builder: (context, snapshot) {
                                        return Text(
                                          snapshot.hasData
                                              ? snapshot.data?.toString() ?? ''
                                              : 'user_name'.tr,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xFF353842),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Spacer(),
                                OutlinedButton(
                                  onPressed: () async {
                                    bloc.getImage();
                                  },
                                  child: Text(
                                    'change_profile_image'.tr,
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Color(0xFF9E3840),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                  ),
                                ),
                                // IconButton(
                                //   icon: SvgPicture.asset(
                                //     'assets/user-cirle.svg',
                                //     width: 30.0, // Adjust size as needed
                                //     height: 30.0, // Adjust size as needed
                                //   ),
                                //   iconSize: 30.0,
                                //   onPressed: () {},
                                // ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.layers,
                                    color: Colors.black, size: 24.0),
                                SizedBox(width: 8.0),
                                Text(
                                  'user_subscription'.tr,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                FutureBuilder(
                                    future: bloc.getUserDay,
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data == 0
                                            ? 'no_active_package'.tr
                                            : '${'remaining_days'.tr}${snapshot.data}' +
                                                "${'day'.tr}",
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color: Color(0xFFFDC00F),
                                        ),
                                      );
                                    }),
                                SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    subscriptionClick();
                                  },
                                  child: Text(
                                    'buy_subscription'.tr,
                                    style: TextStyle(
                                      fontSize: 8.0,
                                      color: Color(0xFF9E3840),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      _buildListItem(
                          'assets/huge-icon-user-outline-users-02.svg',
                          'my_children'.tr,
                          mChildrenScreenClick),
                      Divider(thickness: 0.3),
                      _buildListItem(
                          'assets/huge-icon-user-outline-user-polygon.svg',
                          'support'.tr,
                          sourceClick),
                      Divider(thickness: 0.3),
                      _buildListItem(
                          'assets/huge-icon-time-and-date-outline-calendar-01.svg',
                          'schedule_meeting'.tr,
                          CalendarScreen,
                          disable: false),
                      Divider(thickness: 0.3),
                      _buildListItem(
                          'assets/huge-icon-shipping-and-delivery-outline-package-02.svg',
                          'recommended_subscription_packages'.tr,
                          subscriptionClick),
                      Divider(thickness: 0.3),
                      _buildListItem(
                          'assets/huge-icon-ecommerce-outline-wallet.svg',
                          'my_payments'.tr,
                          transactionsScreen),
                      Divider(thickness: 0.3),
                      _buildListItem(
                          'assets/huge-icon-smart-house-outline-smart-lock.svg',
                          'change_password'.tr,
                          changePasswordClick),
                      SizedBox(height: 16.0),
                      _buildListItem(
                          'assets/huge-icon-communication-outline-calling.svg',
                          'contact_us'.tr, () {
                        contactUsApp();
                      }),
                      SizedBox(height: 16.0),
                      Divider(thickness: 0.3),
                      _buildListItem(
                          'assets/huge-icon-interface-outline-logout-2.svg',
                          'logout'.tr,
                          logoutClick,
                          isLogout: true,
                          logoutColor: Color(0xFFFF1438)),
                    ],
                  ),
                ));
          },
        ));
  }
}

class FactorsTableUi extends StatelessWidget {
  FactorsTableUi({Key? key}) : super(key: key);
  final List<String> columns = [
    'factor_number'.tr,
    'date'.tr,
    'price'.tr,
    'discount_code'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: DataTable(
        columns: List.generate(
          columns.length,
          (index) => DataColumn(
            label: index == 3
                ? const SizedBox()
                : Text(
                    columns[index],
                  ),
          ),
        ),
        rows: List.generate(
          1,
          (index) => DataRow(
            cells: List.generate(
              columns.length,
              (index) => DataCell(
                index == 3 ? const FactorDetailButton() : const Text('-'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FactorDetailButton extends StatelessWidget {
  const FactorDetailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton.icon(
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
        ),
        onPressed: () {},
        icon: const Icon(Icons.remove_red_eye, color: Colors.grey),
        label: Text(
          'see_factor'.tr,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();
    final session = GetIt.I.get<LocalSessionImpl>();

    return WillPopScope(
        onWillPop: () async => false,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            insetPadding: const EdgeInsets.all(WidgetSize.pagePaddingSize),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LOGOUT'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  20.dpv,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();
                            session.clearSession();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginUi()),
                              (Route<dynamic> route) =>
                                  false, // Remove all routes from the stack
                            );
                          },
                          child: Text(
                            'yes'.tr,
                            style: TextStyle(
                              fontFamily: 'IRANSansXFaNum',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      8.dph,
                      Container(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 133, 1, 71),
                                    width: 1),
                              ),
                            ),
                            onPressed: () {
                              GetIt.I.get<NavigationServiceImpl>().pop();
                            },
                            child: Text(
                              'no'.tr,
                              style: TextStyle(
                                fontFamily: 'IRANSansXFaNum',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ))
                    ],
                  ),
                  8.dpv,
                ],
              ),
            ),
          ),
        ));
  }
}
