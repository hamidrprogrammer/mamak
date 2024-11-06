import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/child/AddChildUi.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/DropDownFormField.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/viewModel/child/AddChildViewModel.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:jalali_table_calendar/jalali_table_calendar.dart';

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {
  String _datetime = '';
  String _format = 'yyyy-mm-dd';
  String _value = '';
  String _valuePiker = '';
  DateTime selectedDate = DateTime.now();

  Future _selectDate() async {
    String? picked = await jalaliCalendarPicker(
        context: context,
        convertToGregorian: false,
        showTimePicker: true,
        hore24Format: true);
    if (picked != null) setState(() => _value = picked);
  }

  late DateTime today;
  late Map<DateTime, List<dynamic>> events;

  @override
  void initState() {
    DateTime now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    events = {
      today: ['sample event', 66546],
      today.add(Duration(days: 1)): [6, 5, 465, 1, 66546],
      today.add(Duration(days: 2)): [6, 5, 465, 66546],
    };
    super.initState();
  }

  String numberFormatter(String number, bool persianNumber) {
    Map numbers = {
      '0': '۰',
      '1': '۱',
      '2': '۲',
      '3': '۳',
      '4': '۴',
      '5': '۵',
      '6': '۶',
      '7': '۷',
      '8': '۸',
      '9': '۹',
    };
    if (persianNumber)
      numbers.forEach((key, value) => number = number.replaceAll(key, value));
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: JalaliTableCalendar(
                context: context,
                locale: Locale('fa'),
                // add the events for each day
                events: events,
                //make marker for every day that have some events
                marker: (date, events) {
                  return Positioned(
                    left: 0,
                    top: -3,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[200], shape: BoxShape.circle),
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                        child: Text(
                            numberFormatter((events?.length).toString(), true)),
                      ),
                    ),
                  );
                },
                onMonthChanged: (DateTime date) {
                  print(date);
                },
                isRange: true,
                onRangeChanged: (DateTime start, DateTime end) {
                  print(start);
                  print(end);
                },
                onDaySelected: (DateTime selectDate) {
                  print(selectDate);
                  print(events[selectDate]?[0]);
                }),
          ),
          Text('  مبدّل تاریخ و زمان ,‌ تاریخ هجری شمسی '),
          Text(' تقویم شمسی '),
          Text('date picker شمسی '),
          new ElevatedButton(
            onPressed: _selectDate,
            child: new Text('نمایش تقویم'),
          ),
          new ElevatedButton(
            onPressed: _showDatePicker,
            child: new Text('نمایش دیت پیکر'),
          ),
          Divider(),
          Text(
            "تقویم ",
            textAlign: TextAlign.center,
          ),
          Text(
            _value,
            textAlign: TextAlign.center,
          ),
          Divider(),
          Text(
            _valuePiker,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Display date picker.
  void _showDatePicker() async {
    final bool showTitleActions = false;
    DatePicker.showDatePicker(context,
        minYear: 1300,
        maxYear: 1450,
        confirm: Text(
          'تایید',
          style: TextStyle(color: Colors.red),
        ),
        cancel: Text(
          'لغو',
          style: TextStyle(color: Colors.cyan),
        ),
        dateFormat: _format, onChanged: (year, month, day) {
      if (year == null || month == null || day == null) return;
      if (!showTitleActions) {
        _changeDatetime(year, month, day);
      }
    }, onConfirm: (year, month, day) {
      if (year == null || month == null || day == null) return;
      _changeDatetime(year, month, day);
      _valuePiker =
          " تاریخ ترکیبی : $_datetime  \n سال : $year \n  ماه :   $month \n  روز :  $day";
    });
  }

  void _changeDatetime(int year, int month, int day) {
    setState(() {
      _datetime = '$year-$month-$day';
    });
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String _datetime = '';
  String _format = 'yyyy-mm-dd';
  String _value = '';
  String _valueM = '';
  String _valueMH = '';
  String _valuePiker = '';
  DateTime selectedDate = DateTime.now();

  String selectedTime = "12:30";
  Future _selectDate() async {
    String? picked = await jalaliCalendarPicker(
        context: context,
        convertToGregorian: false,
        showTimePicker: true,
        hore24Format: true);
    if (picked != null) setState(() => _value = picked);
  }

  late DateTime today;
  late Map<DateTime, List<dynamic>> events;

  @override
  void initState() {
    DateTime now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    events = {
      today: ['sample event', 66546],
      today.add(Duration(days: 1)): [6, 5, 465, 1, 66546],
      today.add(Duration(days: 2)): [6, 5, 465, 66546],
    };
    super.initState();
  }

  String numberFormatter(String number, bool persianNumber) {
    Map numbers = {
      '0': '۰',
      '1': '۱',
      '2': '۲',
      '3': '۳',
      '4': '۴',
      '5': '۵',
      '6': '۶',
      '7': '۷',
      '8': '۸',
      '9': '۹',
    };
    if (persianNumber)
      numbers.forEach((key, value) => number = number.replaceAll(key, value));
    return number;
  }

  final TextStyle buttonTextStyle = TextStyle(
    fontFamily: 'IRANSansXFaNum',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5, // This matches the 24px line height
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
        create: (context) => AddChildViewModel(AppState.idle),
        builder: (bloc, state) {
          return Scaffold(
              backgroundColor: Color(0xFFF8F8FC),
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
                        'تعیین جلسه توانمندی',
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      CalendarHeader(),
                      Container(
                        height: 350,
                        child: JalaliTableCalendar(
                            context: context,
                            locale: Locale('fa'),
                            // add the events for each day

                            //make marker for every day that have some events
                            marker: (date, events) {
                              return Positioned(
                                left: 0,
                                top: -3,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(6.0),
                                  child: Center(
                                    child: Text(numberFormatter(
                                        (events?.length).toString(), true)),
                                  ),
                                ),
                              );
                            },
                            onMonthChanged: (DateTime date) {
                              print(date);
                            },
                            isRange: false,
                            showTimePicker: true,
                            onRangeChanged: (DateTime start, DateTime end) {
                              print(start);
                              print(end);
                            },
                            onDaySelected: (DateTime selectDate) {
                              print(selectDate);
                              setState(() {
                                _datetime = selectDate.year.toString() +
                                    "-" +
                                    selectDate.month
                                        .toString()
                                        .padLeft(2, '0') +
                                    "-" +
                                    selectDate.day.toString().padLeft(2, '0');
                              });
                              // print(events[selectDate]?[0]);
                            }),
                      ),
                      SizedBox(height: 12.0),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                      //   child: Text(
                      //     'ساعت جلسه :',
                      //     style: TextStyle(
                      //       fontFamily: 'IRANSansXFaNum',
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: 14,
                      //       color: Color(0xFF505463),
                      //     ),
                      //     textAlign: TextAlign.right,
                      //   ),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Expanded(
                      //       child: Container(
                      //         width: 130,
                      //         margin: EdgeInsets.symmetric(horizontal: 4),
                      //         decoration: BoxDecoration(
                      //           color: Color(0xfff6f6f8),
                      //           borderRadius: BorderRadius.circular(8),
                      //         ),
                      //         child: DropDownFormField(
                      //           selectedItem: DropDownModel(
                      //               data: Get.locale == const Locale('fa', 'IR')
                      //                   ? 1
                      //                   : 24,
                      //               name: "1398"),
                      //           items: positiveIntegers
                      //               .skip(Get.locale == const Locale('fa', 'IR')
                      //                   ? 0
                      //                   : 60)
                      //               .take(60)
                      //               .toList()
                      //               .map((e) => DropDownModel(
                      //                   data: e,
                      //                   name: e.toString().padLeft(2, '0')))
                      //               .toList(),
                      //           name: 'year'.tr,
                      //           onValueChange: (p0) {
                      //             setState(() {
                      //               _valueMH =
                      //                   '${p0.toString().padLeft(2, '0')}:04.055Z';
                      //             });
                      //             print('T ${p0.toString().padLeft(2, '0')}:');
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //     Column(
                      //       children: [],
                      //     ),
                      //     Expanded(
                      //       child: Container(
                      //         width: 130,
                      //         margin: EdgeInsets.symmetric(horizontal: 4),
                      //         decoration: BoxDecoration(
                      //           color: Color(0xfff6f6f8),
                      //           borderRadius: BorderRadius.circular(8),
                      //         ),
                      //         child: DropDownFormField(
                      //           selectedItem: DropDownModel(
                      //               data: Get.locale == const Locale('fa', 'IR')
                      //                   ? 1
                      //                   : 24,
                      //               name: "1398"),
                      //           items: positiveIntegers
                      //               .skip(Get.locale == const Locale('fa', 'IR')
                      //                   ? 1
                      //                   : 2018)
                      //               .take(24)
                      //               .toList()
                      //               .map((e) => DropDownModel(
                      //                   data: e,
                      //                   name: e.toString().padLeft(2, '0')))
                      //               .toList(),
                      //           name: 'year'.tr,
                      //           onValueChange: (p0) {
                      //             setState(() {
                      //               _valueM =
                      //                   'T${p0.toString().padLeft(2, '0')}:';
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      40.dpv,

                      // Column(
                      //   children: [
                      //     Text(
                      //       'ساعت جلسه :',
                      //       style: TextStyle(
                      //         fontFamily: 'IRANSansXFaNum',
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 14,
                      //         color: Color(0xFF505463),
                      //       ),
                      //       textAlign: TextAlign.right,
                      //     ),
                      //     Text(
                      //       'ساعت جلسه :',
                      //       style: TextStyle(
                      //         fontFamily: 'IRANSansXFaNum',
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 14,
                      //         color: Color(0xFF505463),
                      //       ),
                      //       textAlign: TextAlign.right,
                      //     ),
                      //   ],
                      // ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF9E3840),
                            minimumSize: Size(320, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                          onPressed: () {
                            bloc.onChildDateChange(_datetime + 'T00:00:00.0Z');
                            bloc.submitDate();
                          },
                          child: Text(
                            'submit'.tr,
                            style: buttonTextStyle,
                          ),
                        ),
                      )

                      // Container(
                      //   width: 351,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: AssetImage('assets/rectangle-14.svg'),
                      //       fit: BoxFit.fill,
                      //     ),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: Column(
                      //     children: [],
                      //   ),
                      // ),
                      // SessionTimeSelection(
                      //   selectedTime: selectedTime,
                      //   onHourSelect: (value) => setState(() {
                      //     selectedTime = value;
                      //   }),
                      //   onMinuteSelect: (value) => setState(() {
                      //     selectedTime = value;
                      //   }),
                      // ),
                      // Spacer(),
                      // ApprovalButton(),
                      // SizedBox(height: 16.0),
                      // SelectedDateTimeText(
                      //   selectedDate: selectedDate,
                      //   selectedTime: selectedTime,
                      // ),
                      // SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ));
        });
  }
}

class CalendarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'لطفا تاریخ و ساعت جلسه خود را انتخاب کنید.',
        style: TextStyle(
          fontFamily: 'IRANSansXFaNum',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF0C0D0F),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CalendarNavigation extends StatelessWidget {
  final String selectedMonth;
  final int selectedYear;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const CalendarNavigation({
    required this.selectedMonth,
    required this.selectedYear,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: onPrev,
            child: Text(
              'ماه قبل',
              style: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF696F82),
              ),
            ),
          ),
          Row(
            children: [
              SvgPicture.asset(
                  'assets/huge-icon-arrows-solid-direction-left-2.svg'),
              SizedBox(width: 8.0),
              Text(
                '$selectedMonth $selectedYear',
                style: TextStyle(
                  fontFamily: 'IRANSansXFaNum',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF353842),
                ),
              ),
              SizedBox(width: 8.0),
              SvgPicture.asset(
                  'assets/huge-icon-arrows-solid-direction-left-01.svg'),
            ],
          ),
          GestureDetector(
            onTap: onNext,
            child: Text(
              'ماه بعد',
              style: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF696F82),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarDaysHeader extends StatelessWidget {
  final List<Widget> dayHeaders;

  CalendarDaysHeader(this.dayHeaders);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dayHeaders,
      ),
    );
  }
}

class CalendarDayHeader extends StatelessWidget {
  final String day;

  const CalendarDayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: TextStyle(
        fontFamily: 'IRANSansXFaNum',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: Color(0xFF696F82),
      ),
    );
  }
}

class CalendarDate extends StatelessWidget {
  final String date;
  final bool isSelected;
  final void Function()? onSelect;

  const CalendarDate(
    this.date, {
    this.isSelected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            date,
            style: TextStyle(
              fontFamily: 'IRANSansXFaNum',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
              color: isSelected ? Colors.white : Color(0xFF696F82),
            ),
          ),
        ),
      ),
    );
  }
}

class SessionTimeSelection extends StatelessWidget {
  final String selectedTime;
  final ValueChanged<String> onHourSelect;
  final ValueChanged<String> onMinuteSelect;

  const SessionTimeSelection({
    required this.selectedTime,
    required this.onHourSelect,
    required this.onMinuteSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 351,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'ساعت جلسه :',
              style: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF505463),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SessionTimeInput(
                placeholder: 'ساعت',
                selectedValue: selectedTime.split(":")[0],
                onChange: onHourSelect,
              ),
              SessionTimeInput(
                placeholder: 'دقیقه',
                selectedValue: selectedTime.split(":")[1],
                onChange: onMinuteSelect,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SessionTimeInput extends StatelessWidget {
  final String placeholder;
  final String selectedValue;
  final ValueChanged<String> onChange;

  const SessionTimeInput({
    required this.placeholder,
    required this.selectedValue,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 157,
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F8),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: DropdownButton<String>(
        value: selectedValue,
        isExpanded: true,
        underline: SizedBox(),
        items: List.generate(24, (index) => index.toString().padLeft(2, '0'))
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'IRANSansXFaNum',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color(0xFF505463),
              ),
              textAlign: TextAlign.right,
            ),
          );
        }).toList(),
        onChanged: (String? value) {},
      ),
    );
  }
}

class ApprovalButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onPressed: () {
          // Handle approval button press
        },
        child: Text(
          'تایید و ادامه',
          style: TextStyle(
            fontFamily: 'IRANSansXFaNum',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
            height: 1.5, // Line height
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SelectedDateTimeText extends StatelessWidget {
  final Jalali selectedDate;
  final String selectedTime;

  const SelectedDateTimeText({
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'زمان انتخابی شما :\n ${selectedDate.formatter.wN} ${selectedDate.formatter.d} ${selectedDate.formatter.mN} ${selectedDate.year} ساعت $selectedTime',
        style: TextStyle(
          fontFamily: 'IRANSansXFaNum',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xFF505463),
          height: 2.0,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
