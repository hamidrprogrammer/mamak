import 'package:flutter/material.dart';
import 'package:mamak/data/serializer/calendar/UserCalendarResponse.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/main/ConditionalUI.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/ui/newHome/CalendarItemUi.dart';
import 'package:mamak/presentation/ui/newHome/week_item_ui.dart';
import 'package:mamak/presentation/uiModel/newHome/calendar_object_draggable.dart';
import 'package:mamak/presentation/viewModel/calendar/default_calendar_viewModel.dart';

class DefaultCalendarUi extends StatelessWidget {
  const DefaultCalendarUi({super.key});

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (context) => DefaultCalendarViewModel(AppState.idle),
      builder: (bloc, state) {
        return ConditionalUI<List<CalendarItems>>(
          state: state,
          onSuccess: (data) {
            return Container(
              margin: 8.dpe,
              height: data.length * 50,
              child: Padding(
                padding: 8.dpeh,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      children: CalendarObjectDraggable().items.map((item) {
                        return WeekItemUi(item: item);
                      }).toList(),
                    ),
                    8.dph,
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CalendarItemUi(
                            item: data[index],
                            mode: CalendarMode.calendar,
                            index: index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
