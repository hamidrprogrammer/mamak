import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/chart/model/ChartModel.dart';
import 'package:core/chart/radar_chart/radar_chart.dart';
import 'package:core/dioNetwork/interceptor/AuthorizationInterceptor.dart';
import 'package:core/utils/flow/MyFlow.dart';
import 'package:feature/navigation/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mamak/common/user/UserSessionConst.dart';
import 'package:mamak/config/appData/route/AppRoute.dart';
import 'package:mamak/config/uiCommon/MyTheme.dart';
import 'package:mamak/data/serializer/assessment/QuestionsResponse.dart';
import 'package:mamak/data/serializer/calendar/UserCalendarResponse.dart';
import 'package:mamak/data/serializer/user/User.dart';
import 'package:mamak/presentation/ui/assessment/AssessmentItemUi.dart';
import 'package:mamak/presentation/ui/main/MamakTitle.dart';
import 'package:mamak/presentation/ui/newHome/CalendarItemUi.dart';
import 'package:mamak/presentation/uiModel/assessmeny/AssessmentParamsModel.dart';
import 'package:mamak/presentation/viewModel/assessments/AssessmentsViewModel.dart';
import 'package:mamak/useCase/user/LoginUseCase.dart';
import 'package:mamak/useCase/user/RefreshTokenUseCase.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:mamak/data/serializer/child/WorkShopOfUserResponse.dart';
import 'package:mamak/data/serializer/home/CategoryResponse.dart';
import 'package:mamak/presentation/state/NetworkExtensions.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/Home/HomeUI.dart';
import 'package:mamak/presentation/ui/bottomSheets/weekly_plan_sheet.dart';
import 'package:mamak/presentation/ui/main/ConditionalUI.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/MamakScaffold.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/ui/newHome/new_categories_ui.dart';
import 'package:mamak/presentation/ui/newHome/segment_childs_ui.dart';
import 'package:mamak/presentation/ui/workShop/MyWorkShops.dart';
import 'package:mamak/presentation/uiModel/workBook/WorkBookDetailUiModel.dart';
import 'package:mamak/presentation/viewModel/home/CategoriesViewModel.dart';
import 'package:mamak/presentation/viewModel/home/new_home_viewModel.dart';
import 'package:mamak/presentation/viewModel/workBook/GetParticipatedWorkShopsOfChildUserViewModel.dart';
import 'package:mamak/presentation/viewModel/workBook/MyWorkShopsViewModel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/serializer/child/ChildsResponse.dart';

// 09129740143
class CarouselExample extends StatefulWidget {
  final Function(ChildsItem) onSelectChild;
  final Function(ChildsItem) onSelectChildWork;

  final AppState state;
  final ChildsItem? selectedChild;
  const CarouselExample(
      {Key? key,
      required this.state,
      this.selectedChild,
      required this.onSelectChild,
      required this.onSelectChildWork})
      : super(key: key);

  @override
  _CarouselExampleState createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  int _currentIndex = 0;
  bool callApi = false;

  // Image list with Add Child as the first item

  @override
  Widget build(BuildContext context) {
    final NavigationServiceImpl _navigationServiceImpl = GetIt.I.get();

    return ConditionalUI<List<ChildsItem>>(
        showError: false,
        skeleton: const MyLoaderBig(),
        state: widget.state,
        onSuccess: (childs) {
          print("childs=>>>>>>>>>>>>>");
          var index = 0;
          if (widget.selectedChild?.id != null) {
            print(widget.selectedChild!.id.toString());
            index = childs.indexWhere((child) =>
                child.id.toString() == widget.selectedChild!.id.toString());
            if (index == null || index < 0) {
              index = 0;
            }
            print(index);
            print("index==============>");
            if (callApi == false) {
              widget.onSelectChildWork.call(childs[index]);
              widget.onSelectChild.call(childs[index]);
              setState(() {
                callApi = true;
              });
            }
          } else {
            index = 0;
            print("index<<<<==============>>>>>");
            if (callApi == false) {
              widget.onSelectChildWork.call(childs[index]);
              widget.onSelectChild.call(childs[index]);
              setState(() {
                callApi = true;
              });
            }

            widget.onSelectChildWork.call(childs[index]);
            widget.onSelectChild.call(childs[index]);
          }

          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 150, // Height to accommodate image + text
                  autoPlay: false,
                  enlargeCenterPage: true,
                  initialPage: index,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.33, // Shows 3 items on the screen
                  onPageChanged: (index, reason) {
                    widget.onSelectChildWork.call(childs[index]);
                    widget.onSelectChild.call(childs[index]);
                  },
                ),
                items: [
                  ...childs.asMap().entries.map((entry) {
                    int index = entry.key;
                    String name =
                        '${entry.value.childFirstName} ${entry.value.childLastName}';
                    String age = '${entry.value.childAge}';
                    // Regular image slides
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10), // Space between image and text
                        entry.value.childPicture == null ||
                                entry.value.childPicture!.content!.isEmpty
                            ? SvgPicture.asset(
                                './assets/group-2.svg',
                                width: 50,
                                height: 50,
                              )
                            : ClipOval(
                                child: Image.memory(
                                  base64Decode(
                                      entry.value.childPicture!.content ?? ""),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                        SizedBox(height: 5), // Space between image and text
                        Text(
                          "${name}",
                          textAlign: TextAlign.center, // Center the text

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3), // Space between image and text
                        Text(
                          "${age}",
                          textAlign: TextAlign.center, // Center the text

                          style: TextStyle(
                            fontSize: 13,
                            color: const Color.fromARGB(255, 240, 208, 208),
                          ),
                        ),
                      ],
                    );
                  }).toList(),

                  // Add custom "اضافه کردن فرزند" button after all items
                  InkWell(
                    onTap: () {
                      // Handle the button click here
                      _navigationServiceImpl.navigateTo(AppRoute.addChild);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10), // Space between image and text
                        SvgPicture.asset(
                          './assets/group-3.svg',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "add_child".tr,
                          textAlign: TextAlign.center, // Center the text
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}

class AssessmentApp extends StatelessWidget {
  final List<ChildWorkShops> items;
  final ChildsItem? child;
  const AssessmentApp({
    Key? key,
    required this.items,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double widthNormal = screenWidth / 2 - 2;
    print("items.toString()");
    print(items[0].id.toString());
    return Column(
      children: [
        Row(
          children: [
            if (items.length > 0)
              Expanded(
                child: AssessmentCard(
                  width: widthNormal,
                  height: 170,
                  title: '${items[0].workShopTitle}',
                  imagePath: './assets/layer-1-2.svg',
                  backgroundColor: Colors.white,
                  questionsText: "${items[0].questionCount} ${'questions'.tr}",
                  groupText: '${items[0].packageAgeDomain}',
                  borderColor: Colors.redAccent,
                  item: items[0],
                  childsItem: child,
                ),
              ),
            if (items.length > 1)
              Expanded(
                child: AssessmentCard(
                  width: widthNormal,
                  height: 170,
                  title: '${items[1].workShopTitle}',
                  imagePath: './assets/group-48097769-5.svg',
                  backgroundColor: Colors.white,
                  questionsText: "${items[1].questionCount} ${'questions'.tr}",
                  groupText: '${items[1].packageAgeDomain}',
                  borderColor: Colors.yellow,
                  item: items[1],
                  childsItem: child,
                ),
              ),
          ],
        ),
        Row(
          children: [
            if (items.length > 2)
              Expanded(
                child: AssessmentCard(
                  width: widthNormal,
                  height: 170,
                  title: '${items[2].workShopTitle}',
                  imagePath: './assets/group-48097769-4.svg',
                  backgroundColor: Colors.white,
                  questionsText: "${items[2].questionCount} ${'questions'.tr}",
                  groupText: '${items[2].packageAgeDomain}',
                  borderColor: Colors.pinkAccent,
                  isVerticalLayout: true,
                  item: items[2],
                  childsItem: child,
                ),
              ),
            if (items.length > 3)
              Expanded(
                child: AssessmentCard(
                  width: widthNormal,
                  height: 170,
                  title: '${items[3].workShopTitle}',
                  imagePath: './assets/group-48097769-3.svg',
                  backgroundColor: Colors.white,
                  questionsText: "${items[3].questionCount} ${'questions'.tr}",
                  groupText: '${items[3].packageAgeDomain}',
                  borderColor: Colors.tealAccent,
                  isVerticalLayout: true,
                  item: items[3],
                  childsItem: child,
                ),
              ),
          ],
        ),
        if (items.length > 4)
          AssessmentCardTWO(
            width: screenWidth,
            height: 90,
            title: '${items[4].workShopTitle}',
            imagePath: './assets/vectors/group_20_x2.svg',
            backgroundColor: Colors.white,
            questionsText: "${items[4].questionCount} ${'questions'.tr}",
            groupText: '${items[4].packageAgeDomain}',
            borderColor: Colors.blueAccent,
            item: items[4],
            childsItem: child,
          ),
      ],
    );
  }
}

class AssessmentCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final String questionsText;
  final String groupText;
  final Color borderColor;
  final bool isVerticalLayout;
  final double height;
  final double width;
  final ChildWorkShops item;
  final ChildsItem? childsItem;
  const AssessmentCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.questionsText,
    required this.groupText,
    required this.borderColor,
    required this.item,
    required this.childsItem,
    this.isVerticalLayout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print("NavigationServiceImpl");
          print(childsItem?.id);

          if (item.isActive == false) {
            GetIt.I.get<NavigationServiceImpl>().dialog(Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  insetPadding: 32.dpe,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: 16.bRadius),
                    child: Padding(
                      padding: 16.dpe,
                      child: Text(item.InActiveReason ?? ''),
                    ),
                  ),
                ));
            return;
          }
          AssessmentParamsModel assessmentParam = AssessmentParamsModel(
            name: childsItem!.childFirstName ?? '',
            id: item.id?.toString() ??
                ''
                    '',
            childId: childsItem!.id?.toString() ?? '',
            workShopId: item.workShopId?.toString() ?? '',
            course: item.workShopTitle ?? '',
          );
          GetIt.I
              .get<NavigationServiceImpl>()
              .navigateTo(AppRoute.assessments, assessmentParam);
        },
        child: Opacity(
          opacity: item.isActive == true ? 1 : 0.5,
          child: Container(
            width: width, // Adjust width
            height: height,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.isActive == true
                  ? backgroundColor
                  : Color.fromARGB(83, 162, 162, 162),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: item.isActive == true
                      ? borderColor
                      : const Color.fromARGB(255, 196, 196, 196)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Avoid height overflow
              children: [
                SvgPicture.asset(
                  imagePath,
                  width: 35,
                  height: 35,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'IRANSansXFaNum',
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: Color(0xFF272930),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                if (isVerticalLayout)
                  Text(
                    groupText,
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Color(0xFF5A5A5A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 5),
                Text(
                  questionsText,
                  style: TextStyle(
                    fontFamily: 'IRANSansXFaNum',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color(0xFF5A5A5A),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isVerticalLayout)
                  Text(
                    groupText,
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Color(0xFF5A5A5A),
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ));
  }
}

class AssessmentCardTWO extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final String questionsText;
  final String groupText;
  final Color borderColor;
  final bool isVerticalLayout;
  final double height;
  final double width;
  final ChildWorkShops item;
  final ChildsItem? childsItem;
  const AssessmentCardTWO({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.questionsText,
    required this.groupText,
    required this.borderColor,
    required this.item,
    required this.childsItem,
    this.isVerticalLayout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print("NavigationServiceImpl");
          print(childsItem?.id);

          if (item.isActive == false) {
            GetIt.I.get<NavigationServiceImpl>().dialog(Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  insetPadding: 32.dpe,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: 16.bRadius),
                    child: Padding(
                      padding: 16.dpe,
                      child: Text(item.InActiveReason ?? ''),
                    ),
                  ),
                ));
            return;
          }
          AssessmentParamsModel assessmentParam = AssessmentParamsModel(
            name: childsItem!.childFirstName ?? '',
            id: item.id?.toString() ??
                ''
                    '',
            childId: childsItem!.id?.toString() ?? '',
            workShopId: item.workShopId?.toString() ?? '',
            course: item.workShopTitle ?? '',
          );
          GetIt.I
              .get<NavigationServiceImpl>()
              .navigateTo(AppRoute.assessments, assessmentParam);
        },
        child: Opacity(
            opacity: item.isActive == true ? 1 : 0.5,
            child: Container(
              width: width, // Adjust width
              height: height,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.isActive == true
                    ? backgroundColor
                    : Color.fromARGB(83, 162, 162, 162),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: item.isActive == true
                        ? borderColor
                        : const Color.fromARGB(255, 196, 196, 196)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Avoid height overflow
                children: [
                  SvgPicture.asset(
                    imagePath,
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: Color(0xFF272930),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      if (isVerticalLayout)
                        Text(
                          groupText,
                          style: TextStyle(
                            fontFamily: 'IRANSansXFaNum',
                            fontWeight: FontWeight.w400,
                            fontSize: 7,
                            color: Color(0xFF5A5A5A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (!isVerticalLayout)
                        Text(
                          groupText,
                          style: TextStyle(
                            fontFamily: 'IRANSansXFaNum',
                            fontWeight: FontWeight.w400,
                            fontSize: 7,
                            color: Color(0xFF5A5A5A),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 10),
                      Text(
                        questionsText,
                        style: TextStyle(
                          fontFamily: 'IRANSansXFaNum',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Color(0xFF5A5A5A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            )));
  }
}

class NewHomeUi extends StatefulWidget {
  const NewHomeUi({Key? key}) : super(key: key);

  @override
  State<NewHomeUi> createState() => _NewHomeUiState();
}

class _NewHomeUiState extends State<NewHomeUi> with WidgetsBindingObserver {
  bool _isKilled = false;

  @override
  void initState() {
    super.initState();
    _onAppReopened();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App has resumed from the background
      if (_isKilled) {
        _onAppReopened();
        _isKilled = false; // Reset the flag
      }
    } else if (state == AppLifecycleState.paused) {
      // App is in the background
      _isKilled = true; // Set the flag to true if app goes to background
    }
  }

  void _onAppReopened() {
    RefreshUseCase().invoke(MyFlow(flow: (state) {
      if (state.isSuccess) {
        if (state.getData is User) {
          var user = state.getData as User;

          GetIt.I.get<AuthorizationInterceptor>().setToken(user.token ?? '');
          GetIt.I
              .get<AuthorizationInterceptor>()
              .setrefreshToken(user.refreshToken ?? '');
        }
      }
    }));

    // Your function to call when the app is reopened
    print('App was killed and reopened');
    // You can place any function here
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Return false to prevent back navigation
          return false;
        },
        child: MamakScaffold(
          body: CubitProvider(
            create: (context) => NewHomeViewModel(AppState.idle),
            builder: (bloc, state) {
              return CubitProvider(
                  create: (context) =>
                      GetParticipatedWorkShopsOfChildUserViewModel(
                          AppState.idle),
                  builder: (blocW, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 230,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/image.png'),
                                fit: BoxFit
                                    .cover, // This will cover the whole screen
                              ),
                            ),
                            child: Stack(children: [
                              Positioned(
                                left: 70.0, // 50 pixels from the left
                                top: 100.0, // 100 pixels from the top
                                child: Container(
                                    width: 246.0,
                                    height: 50.0,
                                    // Color of the absolutely positioned box
                                    child: Container(
                                      width: 246.0,
                                      height: 50.0,
                                      child: SvgPicture.asset(
                                        './assets/vectors/vector_4_x2.svg',
                                        width: 246,
                                        height:
                                            50, // Change this to match the container size
                                      ),
                                    )),
                              ),
                              Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    SizedBox(
                                      height: 45,
                                    ),
                                    SvgPicture.asset('assets/group-63.svg'),
                                    FutureBuilder(
                                        future: bloc.getChildItem(),
                                        builder: (context, snapshot) {
                                          ChildsItem? selectedChild;
                                          if (snapshot.hasData &&
                                              snapshot.data is ChildsItem) {
                                            selectedChild =
                                                snapshot.data as ChildsItem;
                                          } else {
                                            print("nullllllllll");
                                          }
                                          if (state.isLoading)
                                            return LoadingAnimationWidget
                                                .hexagonDots(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              size: 45,
                                            );

                                          return CarouselExample(
                                            onSelectChild:
                                                bloc.onSelectNewChild,
                                            state: bloc.childState,
                                            selectedChild:
                                                selectedChild, // Pass the selected child
                                            onSelectChildWork:
                                                bloc.onSelectNewChildStorge,
                                          );
                                        })
                                  ])),
                            ]),
                          ),
                          FutureBuilder(
                            future: bloc.getChildItem(),
                            builder: (context, snapshot) {
                              ChildsItem? selectedChild;
                              if (snapshot.hasData &&
                                  snapshot.data is ChildsItem) {
                                selectedChild = snapshot.data as ChildsItem;
                              }
                              return CubitProvider(
                                create: (context) => MyWorkShopsViewModel(
                                    AppState.idle,
                                    selectedChild: selectedChild),
                                builder: (bloc, state) {
                                  return ConditionalUI<WorkShopOfUserResponse>(
                                      showError: false,
                                      skeleton: const MyLoaderBig(),
                                      state: state,
                                      onSuccess: (data) {
                                        if (state.isLoading)
                                          return LoadingAnimationWidget
                                              .hexagonDots(
                                            color: Color.fromARGB(
                                                255, 246, 5, 121),
                                            size: 45,
                                          );
                                        List<ChildWorkShops> items = (data
                                                    .activeUserChildWorkShops ??
                                                []) +
                                            (data.inActiveUserChildWorkShops ??
                                                []);
                                        return Padding(
                                          padding: 15.dpeh,
                                          child: Container(
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      if (items.length > 0)
                                                        SvgPicture.asset(
                                                          'assets/vectors/ellipse_504_x2.svg',
                                                          width: 5,
                                                          height: 5,
                                                        ),
                                                      SizedBox(width: 10),
                                                      if (items.length > 0)
                                                        Text(
                                                          'Evaluation_workshops'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'IRANSansXFaNum',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13,
                                                            color: Color(
                                                                0xFF272930),
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                    ],
                                                  ),
                                                  if (items.length > 0)
                                                    AssessmentApp(
                                                        items: items,
                                                        child: selectedChild),
                                                ],
                                              )),
                                        );
                                      });
                                },
                              );
                            },
                          ),
                          FutureBuilder(
                              future: bloc.getChildItem(),
                              builder: (context, snapshot) {
                                ChildsItem? selectedChild;
                                if (snapshot.hasData &&
                                    snapshot.data is ChildsItem) {
                                  selectedChild = snapshot.data as ChildsItem;
                                  print("nullllllllll");
                                } else {
                                  print("nullllllllll");
                                }

                                return ConditionalUI<WorkBookDetailUiModel>(
                                    showError: false,
                                    state: bloc.reportCardState,
                                    onSuccess: (reportCard) {
                                      if (state.isLoading)
                                        return LoadingAnimationWidget
                                            .hexagonDots(
                                          color:
                                              Color.fromARGB(255, 246, 5, 121),
                                          size: 45,
                                        );
                                      if (state is Error ||
                                          reportCard.cards.length == 0) {
                                        print("EROOOOOOOOOOOOOOOOOOOOOR");
                                        return Center(
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                'assets/icons8_folder.png',
                                                width: 150,
                                                height: 150,
                                              ),
                                              Text(
                                                "no_workbook".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'IRANSansXFaNum',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color(0xFF272930),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      if (reportCard.cards.length == 0)
                                        return Container();

                                      var data = bloc.getTotalChartData(
                                          reportCard.cards,
                                          reportCard.categories);
                                      return Container(
                                        height: 410,
                                        padding: const EdgeInsets.all(10.0),
                                        child: Stack(children: [
                                          Positioned(
                                              child: Center(
                                            child: Column(children: [
                                              SizedBox(
                                                height: 60,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: GroupWidget(
                                                      assetName:
                                                          'assets/group-22-4.svg',
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                                  246, 95, 92)
                                                              .withOpacity(
                                                                  0.05),
                                                      text: 'mathematics'
                                                          .tr, // Use 'mathematics'.tr if using localization
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                  height:
                                                      8), // Space between rows
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GroupWidget(
                                                    assetName:
                                                        'assets/group-22-2.svg',
                                                    backgroundColor:
                                                        Color.fromARGB(255, 248,
                                                                246, 133)
                                                            .withOpacity(0.12),
                                                    text: 'workshop_description'
                                                        .tr, // Use 'workshop_description'.tr if using localization
                                                  ),
                                                  GroupWidget(
                                                    assetName:
                                                        'assets/group-22-5.svg',
                                                    backgroundColor:
                                                        Color.fromARGB(255, 84,
                                                                163, 197)
                                                            .withOpacity(0.05),
                                                    text: 'life_skills'
                                                        .tr, // Use 'life_skills'.tr if using localization
                                                  ),
                                                ],
                                              ),
                                              // Row for bottom items
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GroupWidget(
                                                    assetName:
                                                        'assets/group-22-3.svg',
                                                    backgroundColor:
                                                        Color.fromARGB(255, 220,
                                                                132, 191)
                                                            .withOpacity(0.12),
                                                    text: 'art'
                                                        .tr, // Use 'art'.tr if using localization
                                                  ),
                                                  GroupWidget(
                                                    assetName:
                                                        'assets/group-22.svg',
                                                    backgroundColor:
                                                        Color.fromARGB(255, 253,
                                                                154, 149)
                                                            .withOpacity(0.05),
                                                    text: 'reading_literacy'
                                                        .tr, // Use 'reading_literacy'.tr if using localization
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                  height:
                                                      20), // Space between legend and previous rows

                                              // Legend widgets
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  LegendWidget(
                                                    color: Color(0xFF3D9C68),
                                                    text: 'first_assessment'
                                                        .tr, // Use 'first_assessment'.tr if using localization
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          20), // Space between legends
                                                  LegendWidget(
                                                    color: Color(0xFFF15B67),
                                                    text: 'second_assessment'
                                                        .tr, // Use 'second_assessment'.tr if using localization
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          )),

                                          // Positioned(
                                          //   top:
                                          //       50, // Adjusted for screen height
                                          //   left: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.38, // Adjusted for screen width
                                          //   child: GroupWidget(
                                          //     assetName:
                                          //         'assets/group-22-4.svg',
                                          //     backgroundColor: Color.fromARGB(
                                          //             255, 246, 95, 92)
                                          //         .withOpacity(0.05),
                                          //     text: 'mathematics'.tr,
                                          //   ),
                                          // ),

                                          // // Positioned widget for 'life_skills'
                                          // Positioned(
                                          //   top: MediaQuery.of(context)
                                          //           .size
                                          //           .height *
                                          //       0.2,
                                          //   left: 10,
                                          //   child: GroupWidget(
                                          //     assetName:
                                          //         'assets/group-22-5.svg',
                                          //     backgroundColor: Color.fromARGB(
                                          //             255, 84, 163, 197)
                                          //         .withOpacity(0.05),
                                          //     text: 'life_skills'.tr,
                                          //   ),
                                          // ),

                                          // // Positioned widget for 'workshop_description'
                                          // Positioned(
                                          //   top: 150,
                                          //   left: MediaQuery.of(context)
                                          //           .size
                                          //           .width -
                                          //       100,
                                          //   child: GroupWidget(
                                          //     assetName:
                                          //         'assets/group-22-2.svg',
                                          //     backgroundColor: Color.fromARGB(
                                          //             255, 248, 246, 133)
                                          //         .withOpacity(0.12),
                                          //     text: 'workshop_description'.tr,
                                          //   ),
                                          // ),

                                          // // Positioned widget for 'reading_literacy'
                                          // Positioned(
                                          //   top: 230,
                                          //   left: 10,
                                          //   child: GroupWidget(
                                          //     assetName: 'assets/group-22.svg',
                                          //     backgroundColor: Color.fromARGB(
                                          //             255, 253, 154, 149)
                                          //         .withOpacity(0.05),
                                          //     text: 'reading_literacy'.tr,
                                          //   ),
                                          // ),

                                          // // Positioned widget for 'art'
                                          // Positioned(
                                          //   top: 230,
                                          //   left: MediaQuery.of(context)
                                          //           .size
                                          //           .width -
                                          //       100,
                                          //   child: GroupWidget(
                                          //     assetName:
                                          //         'assets/group-22-3.svg',
                                          //     backgroundColor: Color.fromARGB(
                                          //             255, 220, 132, 191)
                                          //         .withOpacity(0.12),
                                          //     text: 'art'.tr,
                                          //   ),
                                          // ),

                                          // // Positioned widget for Legend widgets
                                          // Positioned(
                                          //   top: 310,
                                          //   left: MediaQuery.of(context)
                                          //           .size
                                          //           .width -
                                          //       100,
                                          //   child: LegendWidget(
                                          //     color: Color(0xFF3D9C68),
                                          //     text: 'first_assessment'.tr,
                                          //   ),
                                          // ),
                                          // Positioned(
                                          //   top: 310,
                                          //   left: MediaQuery.of(context)
                                          //           .size
                                          //           .width -
                                          //       200,
                                          //   child: LegendWidget(
                                          //     color: Color(0xFFF15B67),
                                          //     text: 'second_assessment'.tr,
                                          //   ),
                                          // ),
                                          Center(
                                            child: Column(
                                              children: [
                                                60.dpv,
                                                RadarChart(
                                                  spaceCount: data.maxValue < 5
                                                      ? data.maxValue
                                                      : data.maxValue ~/ 5,
                                                  textScaleFactor: .03,
                                                  labelWidth: 0,
                                                  labelColor: Color.fromARGB(
                                                      0, 255, 255, 255),
                                                  strokeColor: Colors.grey,
                                                  values: [
                                                    ChartModel(
                                                      values: data.values.first,
                                                      color: Color.fromARGB(
                                                          255, 0, 154, 18),
                                                    ),
                                                    if (data.values.length > 1)
                                                      ChartModel(
                                                        values:
                                                            data.values.last,
                                                        color: Color.fromARGB(
                                                            255, 255, 60, 0),
                                                      ),
                                                  ],
                                                  labels: data.name,
                                                  maxValue:
                                                      data.maxValue.toDouble(),
                                                  fillColor: Color.fromARGB(
                                                      255, 37, 169, 0),
                                                  maxLinesForLabels: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10),
                                              SvgPicture.asset(
                                                'assets/vectors/ellipse_504_x2.svg',
                                                width: 5,
                                                height: 5,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Graphical_report_card'.tr,
                                                style: TextStyle(
                                                  fontFamily: 'IRANSansXFaNum',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                  color: Color(0xFF272930),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ]),
                                      );
                                    });
                              }),
                          20.dpv,
                          Padding(
                            padding: 15.dpeh,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/vectors/ellipse_504_x2.svg',
                                  width: 5,
                                  height: 5,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Evaluation_workshops'.tr,
                                  style: TextStyle(
                                    fontFamily: 'IRANSansXFaNum',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color(0xFF272930),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          // const NewCategoriesUi(),
                          FutureBuilder(
                              future: bloc.getChildItem(),
                              builder: (context, snapshot) {
                                ChildsItem? selectedChild;
                                if (snapshot.hasData &&
                                    snapshot.data is ChildsItem) {
                                  selectedChild = snapshot.data as ChildsItem;
                                  print("nullllllllll");
                                } else {
                                  print("nullllllllll");
                                }
                                if (selectedChild != null)
                                  return WeeklyPlanSheet(
                                      childsItem: selectedChild);

                                return Column();
                              }),
                          54.dpv
                        ],
                      ),
                    );
                  });
            },
          ),
        ));
  }
}

// class WeeklyScheduleApp extends StatelessWidget {
//   final List<ChildWorkShops> items;
//   final ChildsItem? child;
//   final Function(ChildWorkShops) onPress;

//   const WeeklyScheduleApp(
//       {Key? key,
//       required this.items,
//       required this.child,
//       required this.onPress});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> weekDaysInPersian = [
//       'Saturday'.tr,
//       'Sunday'.tr,
//       'Monday'.tr,
//       'Tuesday'.tr,
//       'Wednesday'.tr
//     ];

//     int daysUntilNextSaturday() {
//       final DateTime now = DateTime.now();
//       int currentWeekday = now.weekday;
//       return currentWeekday;
//     }

//     int countSaturdaysPassed() {
//       final DateTime now = DateTime.now();
//       DateTime startOfYear = DateTime(now.year, 1, 1);
//       int passedSaturdays = 0;

//       while (startOfYear.isBefore(now)) {
//         if (startOfYear.weekday == DateTime.saturday) {
//           passedSaturdays++;
//         }
//         startOfYear = startOfYear.add(Duration(days: 1));
//       }
//       return passedSaturdays;
//     }

//     String getJalaliDateForDay(int dayOffset) {
//       final DateTime now = DateTime.now();
//       final DateTime targetDate = now
//           .subtract(Duration(days: now.weekday - 6))
//           .add(Duration(days: dayOffset));
//       final Jalali jalaliDate = Jalali.fromDateTime(targetDate);
//       final String locale = Localizations.localeOf(context).toString();
//       print(Get.locale);
//       // Check if the locale is Farsi
//       if (Get.locale.toString() == "fa_IR") {
//         // Return Jalali date in Farsi
//         return '${jalaliDate.day} ${jalaliDate.formatter.mN}'; // Persian month and day
//       } else {
//         // Return Jalali date in European format (day/month/year)
//         return '${targetDate.day}/${targetDate.month}/${targetDate.year}'; // European date format
//       }
//     }

//     int daysUntilSaturday = daysUntilNextSaturday();

//     return Column(
//       children: [
//         SizedBox(height: 15),
//         if (items.length > 0)
//           ScheduleItem(
//               day: '${weekDaysInPersian[0]} ${getJalaliDateForDay(0)} :',
//               title: '${items[0].workShopTitle}',
//               iconPath: './assets/group-22-4.svg',
//               backgroundColor: Color(0xFFFDEFEF),
//               borderColor: daysUntilSaturday == 6
//                   ? Colors.redAccent
//                   : const Color.fromARGB(255, 255, 255, 255),
//               showButton: daysUntilSaturday == 6,
//               items: items,
//               childsItem: child,
//               onPress: () {
//                 onPress(items[0]);
//               }),
//         if (items.length > 1)
//           ScheduleItem(
//               day: '${weekDaysInPersian[1]} ${getJalaliDateForDay(1)} :',
//               title: '${items[1].workShopTitle}',
//               iconPath: './assets/group-22-2.svg',
//               backgroundColor: Color(0xFFE9DEE2),
//               items: items,
//               childsItem: child,
//               borderColor: daysUntilSaturday == 7
//                   ? Colors.redAccent
//                   : const Color.fromARGB(255, 255, 255, 255),
//               showButton: daysUntilSaturday == 7,
//               onPress: () {
//                 onPress(items[1]);
//               }),
//         if (items.length > 2)
//           ScheduleItem(
//               day: '${weekDaysInPersian[2]} ${getJalaliDateForDay(2)} :',
//               title: '${items[2].workShopTitle}',
//               iconPath: './assets/group-22-3.svg',
//               backgroundColor: Color(0xFFD1E3E8),
//               borderColor: daysUntilSaturday == 1
//                   ? Colors.redAccent
//                   : const Color.fromARGB(255, 255, 255, 255),
//               showButton: daysUntilSaturday == 1,
//               items: items,
//               childsItem: child,
//               onPress: () {
//                 onPress(items[2]);
//               }),
//         if (items.length > 3)
//           ScheduleItem(
//               day: '${weekDaysInPersian[3]} ${getJalaliDateForDay(3)} :',
//               title: '${items[3].workShopTitle}',
//               iconPath: './assets/group-22-5.svg',
//               backgroundColor: Color(0xFFECC3C1),
//               borderColor: daysUntilSaturday == 2
//                   ? Colors.redAccent
//                   : const Color.fromARGB(255, 255, 255, 255),
//               showButton: daysUntilSaturday == 2,
//               items: items,
//               childsItem: child,
//               onPress: () {
//                 onPress(items[3]);
//               }),
//         if (items.length > 4)
//           ScheduleItem(
//               day: '${weekDaysInPersian[4]} ${getJalaliDateForDay(4)} :',
//               title: '${items[4].workShopTitle}',
//               iconPath: './assets/group-22.svg',
//               backgroundColor: Color(0xFFFDFC95),
//               borderColor: daysUntilSaturday == 3
//                   ? Colors.redAccent
//                   : const Color.fromARGB(255, 255, 255, 255),
//               showButton: daysUntilSaturday == 3,
//               items: items,
//               childsItem: child,
//               onPress: () {
//                 onPress(items[4]);
//               }),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20.0),
//           child: Text(
//             'You_can_customize_your_weekly_schedule_by_switching_days'.tr,
//             style: TextStyle(
//               fontFamily: 'IRANSansXFaNum',
//               fontWeight: FontWeight.w500,
//               fontSize: 12,
//               color: Color(0xFF2E754E),
//             ),
//             textAlign: TextAlign.right,
//           ),
//         ),
//       ],
//     );
//   }
// }

class StartAssessmentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              SvgPicture.asset(
                './assets/group-22.svg',
                width: 24,
                height: 24,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluation_date'.tr,
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF353842),
                    ),
                  ),
                  Text(
                    'Life_skills'.tr,
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF353842),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF9E3840),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Start_evaluation'.tr,
            style: TextStyle(
              fontFamily: 'IRANSansXFaNum',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class ScheduleItem extends StatelessWidget {
  final String day;
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final Color borderColor;
  final bool showButton;
  final ChildsItem? childsItem;

  final Function onPress;
  final CalendarItems items;
  final CalendarMode mode;
  const ScheduleItem(
      {Key? key,
      required this.day,
      required this.title,
      required this.iconPath,
      required this.backgroundColor,
      required this.borderColor,
      required this.items,
      required this.mode,
      required this.onPress,
      this.childsItem,
      required this.showButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SvgPicture.asset(
              this.iconPath,
              width: 24,
              height: 24,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              this.day,
              style: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color: Color(0xFF353842),
              ),
            ),
          ]),
          Text(
            this.title,
            style: TextStyle(
              fontFamily: 'IRANSansXFaNum',
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: Color(0xFF353842),
            ),
          ),
          if (showButton)
            InkWell(
              onTap: () {
                onPress();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF9E3840),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'Start_evaluation'.tr,
                  style: TextStyle(
                    fontFamily: 'IRANSansXFaNum',
                    fontWeight: FontWeight.w600,
                    fontSize: 7,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
// 09129740143

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Chart Example'),
        ),
        body: Center(
          child: Container(
            width: 351,
            height: 354,
            child: Stack(
              children: [
                Positioned(
                  top: 37,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/rectangle-14.svg',
                    width: 351,
                    height: 317,
                  ),
                ),
                Positioned(
                  top: 61,
                  left: 137,
                  child: GroupWidget(
                    assetName: 'assets/group-22-2.svg',
                    backgroundColor: Color(0xFFFEFC95).withOpacity(0.12),
                    text: 'workshop_description'.tr,
                  ),
                ),
                Positioned(
                  top: 111,
                  left: 12,
                  child: GroupWidget(
                    assetName: 'assets/group-22-3.svg',
                    backgroundColor: Color(0xFFD291BC).withOpacity(0.12),
                    text: 'هنر',
                  ),
                ),
                Positioned(
                  top: 111,
                  left: 257,
                  child: GroupWidget(
                    assetName: 'assets/group-22-4.svg',
                    backgroundColor: Color(0xFFF66967).withOpacity(0.05),
                    text: 'ریاضی',
                  ),
                ),
                Positioned(
                  top: 240,
                  left: 12,
                  child: GroupWidget(
                    assetName: 'assets/group-22.svg',
                    backgroundColor: Color(0xFF82B5CA).withOpacity(0.05),
                    text: 'سواد خواندن',
                  ),
                ),
                Positioned(
                  top: 240,
                  left: 257,
                  child: GroupWidget(
                    assetName: 'assets/group-22-5.svg',
                    backgroundColor: Color(0xFFECC3C1).withOpacity(0.05),
                    text: 'مهارت های زندگی',
                  ),
                ),
                Positioned(
                  top: 155.5,
                  left: 103,
                  child: SvgPicture.asset(
                    'assets/vector-3.svg',
                    width: 135,
                    height: 97,
                  ),
                ),
                Positioned(
                  top: 315,
                  left: 288,
                  child: LegendWidget(
                    color: Color(0xFF3D9C68),
                    text: 'ارزیابی اول',
                  ),
                ),
                Positioned(
                  top: 315,
                  left: 211,
                  child: LegendWidget(
                    color: Color(0xFFF15B67),
                    text: 'ارزیابی دوم',
                  ),
                ),
                Positioned(
                  top: 121.5,
                  left: 136,
                  child: SvgPicture.asset(
                    'assets/vector-5.svg',
                    width: 69.5,
                    height: 129.5,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/group-21.svg',
                      width: 161,
                      height: 161,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 156,
                  child: Text(
                    'نمودار گرافیکی کارنامه همه جانبه',
                    style: TextStyle(
                      fontFamily: 'IRANSansXFaNum',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF272930),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupWidget extends StatelessWidget {
  final String assetName;
  final Color backgroundColor;
  final String text;

  GroupWidget({
    required this.assetName,
    required this.backgroundColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          assetName,
          width: 28,
          height: 28,
        ),
        SizedBox(height: 5),
        Container(
          width: 82,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: Color(0xFF353842),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LegendWidget extends StatelessWidget {
  final Color color;
  final String text;

  LegendWidget({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: color,
          ),
        ),
      ],
    );
  }
}
