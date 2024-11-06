import 'dart:convert';
import 'dart:typed_data';
import 'package:core/chart/model/ChartModel.dart';
import 'package:core/chart/radar_chart/radar_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mamak/core/network/errorHandler/ErrorModel.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';
import 'package:mamak/data/serializer/workBook/WorkBooksResponse.dart';
import 'package:mamak/presentation/state/NetworkExtensions.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/main/ConditionalUI.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/MamakScaffold.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/ui/newHome/new_home_ui.dart';
import 'package:mamak/presentation/ui/workBook/MothersWorkBookTabsUi.dart';
import 'package:mamak/presentation/uiModel/workBook/WorkBookDetailUiModel.dart';
import 'package:mamak/presentation/viewModel/home/new_home_viewModel.dart';
import 'package:mamak/presentation/viewModel/workBook/GetParticipatedWorkShopsOfChildUserViewModel.dart';

class WorkBookUi extends StatelessWidget {
  const WorkBookUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (context) => NewHomeViewModel(AppState.idle),
      builder: (blocMain, state) {
        if (state.isLoading)
          return Center(
              child: LoadingAnimationWidget.hexagonDots(
            color: Color.fromARGB(255, 246, 5, 121),
            size: 45,
          ));

        return FutureBuilder(
            future: blocMain.getChildItem(),
            builder: (context, snapshot) {
              ChildsItem? selectedChild;
              if (snapshot.hasData && snapshot.data is ChildsItem) {
                selectedChild = snapshot.data as ChildsItem;
              }
              if (selectedChild == null) {
                return Center(child: Text("No child selected"));
              }

              Uint8List bytes =
                  base64Decode(selectedChild.childPicture?.content ?? '');

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
                          "report_card".tr,
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
                  child: Column(
                    children: [
                      CubitProvider(
                        create: (context) => NewHomeViewModel(AppState.idle),
                        builder: (blocMain, state) {
                          if (state.isLoading)
                            return LoadingAnimationWidget.hexagonDots(
                              color: Color.fromARGB(255, 246, 5, 121),
                              size: 45,
                            );

                          return CubitProvider(
                            create: (context) =>
                                GetParticipatedWorkShopsOfChildUserViewModel(
                                    AppState.idle),
                            builder: (bloc, state) {
                              if (state.isLoading)
                                return Center(
                                  child: LoadingAnimationWidget.hexagonDots(
                                    color: Color.fromARGB(255, 246, 5, 121),
                                    size: 45,
                                  ),
                                );

                              if (state is Error) {
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

                              return ConditionalUI<List<WorkBook>>(
                                state: state,
                                showError: true,
                                onSuccess: (data) {
                                  if (!data.any(
                                      (element) => element.workShopId != -1)) {
                                    data.add(WorkBook(workShopId: -1));
                                  }

                                  return Column(
                                    children: [
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          bytes.length > 10
                                              ? Image.memory(
                                                  bytes,
                                                  width: 32,
                                                  height: 32,
                                                )
                                              : SvgPicture.asset(
                                                  'assets/group-60.svg',
                                                  width: 32,
                                                  height: 32,
                                                ),
                                          SizedBox(width: 10),
                                          Text(
                                            '${selectedChild?.childFirstName}',
                                            style: TextStyle(
                                              fontFamily: 'IRANSansXFaNum',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Color(0xFF696F82),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '${selectedChild?.childAge ?? ""}',
                                            style: TextStyle(
                                              fontFamily: 'IRANSansXFaNum',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color(0xFF696F82),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "select_workshop".tr,
                                        style: TextStyle(
                                          fontFamily: 'IRANSansXFaNum',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(0xFF272930),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 12),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          if (data[index].workShopId == -1) {
                                            return const SizedBox(height: 50);
                                          }
                                          return Column(
                                            children: [
                                              buildWorkshopSelection(
                                                '${data[index].workShopTitle}',
                                                data[index]
                                                        .workShopFileContent ??
                                                    '',
                                                Color(0xFF82B5CA),
                                                () {
                                                  num? lastId;
                                                  String? lastAgeDomain;
                                                  for (var element in data) {
                                                    double pAge =
                                                        double.tryParse(element
                                                                .toAgeDomain
                                                                .toString()) ??
                                                            0.0;
                                                    double cAge =
                                                        double.tryParse(data[
                                                                    index]
                                                                .toAgeDomain
                                                                .toString()) ??
                                                            0.0;
                                                    if (element.workShopFileContent ==
                                                            data[index]
                                                                .workShopFileContent &&
                                                        pAge < cAge) {
                                                      lastId =
                                                          element.workShopId;
                                                      lastAgeDomain = element
                                                          .packageAgeDomain;
                                                    }
                                                  }
                                                  bloc.gotoDetailView(
                                                      data[index].workShopId,
                                                      lastId: lastId,
                                                      lastAgeDomain:
                                                          lastAgeDomain);
                                                },
                                              ),
                                              SizedBox(height: 12),
                                            ],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      ),
                                      CubitProvider(
                                          create: (context) =>
                                              NewHomeViewModel(AppState.idle),
                                          builder: (bloc, state) {
                                            return ConditionalUI<
                                                WorkBookDetailUiModel>(
                                              showError: false,
                                              skeleton: const MyLoaderBig(),
                                              state: bloc.reportCardState,
                                              onSuccess: (reportCard) {
                                                var data =
                                                    bloc.getTotalChartData(
                                                        reportCard.cards,
                                                        reportCard.categories);
                                                return Container(
                                                  height: 350,
                                                  child: Stack(children: [
                                                    Positioned(
                                                      top: 70,
                                                      left: 125,
                                                      child: GroupWidget(
                                                        assetName:
                                                            'assets/group-22-4.svg',
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                    246, 95, 92)
                                                                .withOpacity(
                                                                    0.05),
                                                        text: 'mathematics'.tr,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 140,
                                                      left: 10,
                                                      child: GroupWidget(
                                                        assetName:
                                                            'assets/group-22-5.svg',
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                    255,
                                                                    84,
                                                                    163,
                                                                    197)
                                                                .withOpacity(
                                                                    0.05),
                                                        text: 'life_skills'.tr,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 140,
                                                      left: 245,
                                                      child: GroupWidget(
                                                        assetName:
                                                            'assets/group-22-2.svg',
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                    255,
                                                                    248,
                                                                    246,
                                                                    133)
                                                                .withOpacity(
                                                                    0.12),
                                                        text:
                                                            'workshop_description'
                                                                .tr,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 250,
                                                      left: 20,
                                                      child: GroupWidget(
                                                        assetName:
                                                            'assets/group-22.svg',
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                    255,
                                                                    253,
                                                                    154,
                                                                    149)
                                                                .withOpacity(
                                                                    0.05),
                                                        text: 'reading_literacy'
                                                            .tr,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 250,
                                                      left: 230,
                                                      child: GroupWidget(
                                                        assetName:
                                                            'assets/group-22-3.svg',
                                                        backgroundColor:
                                                            Color.fromARGB(
                                                                    255,
                                                                    220,
                                                                    132,
                                                                    191)
                                                                .withOpacity(
                                                                    0.12),
                                                        text: 'art'.tr,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 315,
                                                      left: 288,
                                                      child: LegendWidget(
                                                        color:
                                                            Color(0xFF3D9C68),
                                                        text: 'first_assessment'
                                                            .tr,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 315,
                                                      left: 190,
                                                      child: LegendWidget(
                                                        color:
                                                            Color(0xFFF15B67),
                                                        text:
                                                            'second_assessment'
                                                                .tr,
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Column(
                                                        children: [
                                                          60.dpv,
                                                          RadarChart(
                                                            spaceCount: data
                                                                        .maxValue <
                                                                    5
                                                                ? data.maxValue
                                                                : data.maxValue ~/
                                                                    5,
                                                            labelWidth: 0,
                                                            labelColor:
                                                                Color.fromARGB(
                                                                    0,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            textScaleFactor:
                                                                .03,
                                                            strokeColor:
                                                                Colors.grey,
                                                            values: [
                                                              ChartModel(
                                                                values: data
                                                                    .values
                                                                    .first,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        154,
                                                                        18),
                                                              ),
                                                              if (data.values
                                                                      .length >
                                                                  1)
                                                                ChartModel(
                                                                  values: data
                                                                      .values
                                                                      .last,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          60,
                                                                          0),
                                                                ),
                                                            ],
                                                            labels: data.name,
                                                            maxValue: data
                                                                .maxValue
                                                                .toDouble(),
                                                            fillColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    37,
                                                                    169,
                                                                    0),
                                                            maxLinesForLabels:
                                                                1,
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
                                                          'Graphical_report_card'
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
                                                  ]),
                                                );
                                              },
                                            );
                                          }),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Widget buildWorkshopSelection(String title, String iconPath,
      Color backgroundColor, Function() onSelect) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: Image.memory(
                base64Decode(iconPath),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'IRANSansXFaNum',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xFF272930),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
