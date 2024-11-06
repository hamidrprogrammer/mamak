import 'package:flutter/material.dart';
import 'package:mamak/data/body/calendar/home_calendar.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';

class WeeklyPlanSheet extends StatelessWidget {
  final ChildsItem childsItem;

  const WeeklyPlanSheet({super.key, required this.childsItem});

  @override
  Widget build(BuildContext context) {
    return HomeCalendarUi(selectedChild: childsItem);
  }
}
