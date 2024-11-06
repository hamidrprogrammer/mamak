import 'dart:convert';

import 'package:feature/messagingService/MessagingService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mamak/data/serializer/workBook/WorkBookDetailResponse.dart';
import 'package:mamak/presentation/viewModel/workBook/ReportCardViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkDetails extends StatelessWidget {
  const WorkDetails({Key? key}) : super(key: key);

  Future<List<Accordion>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    return favorites
        .map((item) => Accordion.fromJson(jsonDecode(item)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final accordionViewModel = Get.arguments as Accordion;
    var messageService = GetIt.I.get<MessagingServiceImpl>();

    return Scaffold(
      backgroundColor: Color(0xfff8f8fc),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Positioned.fill(
              top: kIsWeb ? 0 : 15,
              child: Image.asset(
                'assets/Rectangle21.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            AppBar(
              title: Text(
                'appBarTitle'.tr,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  SvgPicture.asset('assets/vectors/ellipse_507_x2.svg',
                      width: 6, height: 6),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      accordionViewModel.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff272930),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                accordionViewModel.workMethod,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff353842),
                  height: 1.8,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow(context, 'learningOpportunity',
                  accordionViewModel.learningOpportunity, Color(0xff3d9c68)),
              SizedBox(height: 24),
              _buildInfoRow(context, 'tools', accordionViewModel.requiredTools,
                  Color(0xffc74953)),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Color(0xfff8f8fc),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xff9e3840)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              List<String> favorites = prefs.getStringList('favorites') ?? [];

              favorites.add(jsonEncode(accordionViewModel.toJson()));
              await prefs.setStringList('favorites', favorites);
              messageService.showSnackBar(
                'successfully'.tr,
              );
            },
            child: Text(
              'addToSavedList'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff9e3840),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildInfoRow(
      BuildContext context, String labelKey, String content, Color color) {
    return Row(
      children: [
        SizedBox(width: 8),
        SvgPicture.asset('assets/vectors/ellipse_507_x2.svg',
            width: 4, height: 4),
        SizedBox(width: 2),
        Text(
          labelKey.tr,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: color,
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 200,
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Color(0xa3a7b514),
            borderRadius: BorderRadius.circular(20.0),
          ),
          constraints: BoxConstraints(maxWidth: 280),
          child: Text(
            content,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color(0xff505463),
            ),
            maxLines: 100,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
