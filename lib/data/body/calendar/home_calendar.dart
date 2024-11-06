import 'package:feature/navigation/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mamak/config/appData/route/AppRoute.dart';
import 'package:mamak/data/serializer/calendar/UserCalendarResponse.dart';
import 'package:mamak/data/serializer/child/ChildsResponse.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/main/ConditionalUI.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/ui/newHome/draggable_calendar_ui.dart';
import 'package:mamak/presentation/ui/newHome/verticalSlider/VerticalSlider.dart';
import 'package:mamak/presentation/uiModel/assessmeny/AssessmentParamsModel.dart';
import 'package:mamak/presentation/viewModel/calendar/calendar_viewModel.dart';

class HomeCalendarUi extends StatefulWidget {
  const HomeCalendarUi({
    Key? key,
    required this.selectedChild,
  }) : super(key: key);
  final ChildsItem selectedChild;

  @override
  State<HomeCalendarUi> createState() => _HomeCalendarUiState();
}

class _HomeCalendarUiState extends State<HomeCalendarUi> {
  late CalendarViewModel viewModel;

  @override
  void initState() {
    viewModel = CalendarViewModel(AppState.idle);
    viewModel.setUserChildId(widget.selectedChild.id ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (context) => viewModel,
      builder: (bloc, state) {
        return ConditionalUI<UserCalendarResponse>(
          state: bloc.calendarState,
          onSuccess: (data) {
            data.calendarItems
                ?.sort((a, b) => a.dayOfWeek!.compareTo(b.dayOfWeek!));
            return Column(
              children: [
                4.dpv,
                DraggableCalendarUi(
                    items: data.calendarItems ?? [],
                    onClick: bloc.onSubmitClick,
                    selectedChild: widget.selectedChild),
              ],
            );
          },
        );
      },
    );
  }
}
