import 'package:core/utils/flow/MyFlow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mamak/data/serializer/workBook/WorkBooksResponse.dart';
import 'package:mamak/presentation/state/app_state.dart';
import 'package:mamak/presentation/ui/child/AddChildUi.dart';
import 'package:mamak/presentation/ui/main/ConditionalUI.dart';
import 'package:mamak/presentation/ui/main/CubitProvider.dart';
import 'package:mamak/presentation/ui/main/DropDownFormField.dart';
import 'package:mamak/presentation/ui/main/MyLoader.dart';
import 'package:mamak/presentation/ui/main/UiExtension.dart';
import 'package:mamak/presentation/ui/user/profile/Meeting.dart';
import 'package:mamak/presentation/viewModel/child/AddChildViewModel.dart';
import 'package:mamak/useCase/child/AdddataUseVase.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:jalali_table_calendar_plus/jalali_table_calendar_plus.dart';
import 'package:mamak/presentation/state/NetworkExtensions.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // Future _selectDate() async {
  //   String? picked = await jalaliCalendarPicker(
  //       context: context,
  //       convertToGregorian: false,
  //       showTimePicker: true,
  //       hore24Format: true);
  //   if (picked != null) setState(() => _value = picked);
  // }

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
    getReservedMeeting();
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
    fontSize: 11,
    color: Colors.white,
  );
  bool isLoading = false;
  String errorMessage = '';
  int meetings = 1;
  int change = 0;

  late Meeting meetingData;

  void getReservedMeeting() {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    AdddataUseVase().getReservedMeeting(MyFlow(flow: (appState) {
      setState(() {
        if (appState.isSuccess) {
          print("appState.getData is Meeting");
          print(appState.getData is Meeting);
          // Assuming `getReservedMeetings` returns a list of meetings
          meetings = 0; // Update with actual data from response
          if (appState.getData is Meeting) {
            Meeting response = appState.getData;
            meetingData = response;
            _datetime = response.executionDate!;
            setState(() {
              change = 0;
              meetings = 0;
              meetingData = response;
              _datetime = response.executionDate!;
              isLoading = false;
            });
          }
        } else if (appState.isFailed) {
          setState(() {
            change = 0;
            meetings = 1;

            isLoading = false;
          });
          meetings = 1;
          errorMessage =
              appState.getErrorModel?.message ?? 'Failed to fetch meetings';
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    bool range = false;
    Map<DateTime, List<dynamic>> events = {
      today: ['sample event', 26],
      today.add(const Duration(days: 1)): [
        'all types can use here',
        {"key": "value"}
      ],
    };
    Future<void> launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return CubitProvider(
        create: (context) => AddChildViewModel(AppState.idle),
        builder: (bloc, state) {
          print(state);
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
              body: isLoading == true
                  ? Center(
                      child: LoadingAnimationWidget.hexagonDots(
                      color: Color.fromARGB(255, 246, 5, 121),
                      size: 45,
                    ))
                  : Scaffold(
                      body: meetings == 1
                          ? SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    CalendarHeader(),
                                    Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 239, 135, 142),
                                          minimumSize: Size(320, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "زمان انتخابی شما ${_valuePiker}",
                                          style: buttonTextStyle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color(0xFF9E3840),
                                          minimumSize: Size(320, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                        ),
                                        onPressed: () {
                                          if (change == 0) {
                                            bloc.onChildDateChange(
                                                _datetime + 'T00:00:00.0Z');
                                            bloc.submitDate();
                                          } else {
                                            bloc.onChildDateChange(
                                                _datetime + 'T00:00:00.0Z');
                                            bloc.submitChangeEmpowermentMeetingExecutionDate();
                                          }
                                          getReservedMeeting();
                                        },
                                        child: bloc.state.isLoading
                                            ? const MyLoader()
                                            : Text(
                                                'تایید اطلاعات و رزرو جلسه مشاوره رایگان',
                                                style: buttonTextStyle,
                                              ),
                                      ),
                                    ),
                                    Container(
                                        height: 470,
                                        child: JalaliTableCalendar(
                                          events: events,
                                          range: range,
                                          option: JalaliTableCalendarOption(
                                            daysStyle: TextStyle(
                                              fontFamily: 'IRANSansXFaNum',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              height:
                                                  2, // This matches the 24px line height
                                              color: Color.fromARGB(
                                                  255, 14, 14, 14),
                                            ),
                                            currentDayColor:
                                                const Color.fromARGB(
                                                    255, 67, 163, 2),
                                            daysOfWeekStyle: TextStyle(
                                              fontFamily: 'IRANSansXFaNum',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              height:
                                                  2, // This matches the 24px line height
                                              color: Color.fromARGB(
                                                  255, 14, 14, 14),
                                            ),
                                            headerStyle: TextStyle(
                                              fontFamily: 'IRANSansXFaNum',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              height:
                                                  2, // This matches the 24px line height
                                              color: Color.fromARGB(
                                                  255, 14, 14, 14),
                                            ),
                                            daysOfWeekTitles: [
                                              "شنبه",
                                              "یکشنبه",
                                              "دوشنبه",
                                              "سه شنبه",
                                              "چهارشنبه",
                                              "پنجشنبه",
                                              "جمعه"
                                            ],
                                          ),
                                          customHolyDays: [
                                            // use jalali month and day for this
                                            HolyDay(
                                                month: 4,
                                                day: 10), // For Repeated Days
                                            HolyDay(
                                                year: 1404,
                                                month: 1,
                                                day: 26), // For Only One Day
                                          ],
                                          onRangeSelected: (selectedDates) {
                                            for (DateTime date
                                                in selectedDates) {
                                              print(date);
                                            }
                                          },
                                          marker: (date, event) {
                                            if (event.isNotEmpty) {
                                              return Positioned(
                                                  top: -2,
                                                  left: 1,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              color:
                                                                  Colors.blue),
                                                      child: Text(event.length
                                                          .toString())));
                                            }
                                            return null;
                                          },
                                          onDaySelected: (DateTime date) {
                                            print(date.toJalali().formatter.mN);
                                            setState(() {
                                              _datetime = date.year.toString() +
                                                  "-" +
                                                  date.month
                                                      .toString()
                                                      .padLeft(2, '0') +
                                                  "-" +
                                                  date.day
                                                      .toString()
                                                      .padLeft(2, '0');
                                              _valuePiker = date
                                                      .toJalali()
                                                      .formatter
                                                      .d +
                                                  "  " +
                                                  date.toJalali().formatter.mN +
                                                  "  " +
                                                  date
                                                      .toJalali()
                                                      .formatter
                                                      .yyyy;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "شما برای آشنایی بیشتر با گروه مامک با پشتیبان خود جلسه مشاوره دارید.",
                                      style: TextStyle(
                                        fontFamily: 'IRANSansXFaNum',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        height:
                                            2, // This matches the 24px line height
                                        color: Color.fromARGB(255, 14, 14, 14),
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                    Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 239, 135, 142),
                                          minimumSize: Size(320, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "زمان انتخابی شما ${meetingData?.executionDate != null ? new Jalali.fromDateTime(DateTime.parse(meetingData!.executionDate!)).formatter.d + " " + new Jalali.fromDateTime(DateTime.parse(meetingData!.executionDate!)).formatter.mN + " " + new Jalali.fromDateTime(DateTime.parse(meetingData!.executionDate!)).formatter.yyyy : 'تاریخ نامشخص'}",
                                          style: buttonTextStyle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30.0),
                                    Text(
                                      "جلسه شما بر بستر اپلیکیشن اسکای روم انجام می شود و ساعاتی قبل از جلسه دکمه پیوستن به جلسه برای شما فعال می شود.",
                                      style: TextStyle(
                                        fontFamily: 'IRANSansXFaNum',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        height:
                                            2, // This matches the 24px line height
                                        color: Color.fromARGB(255, 14, 14, 14),
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                    Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color(0xFF9E3840),
                                          minimumSize: Size(320, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 11, horizontal: 16),
                                        ),
                                        onPressed: () {
                                          launchURL(meetingData.skyRoomLink!);
                                        },
                                        child: bloc.state.isLoading
                                            ? const MyLoader()
                                            : Text(
                                                'پیوستن به جلسه',
                                                style: buttonTextStyle,
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                    Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 243, 239, 239),
                                          minimumSize: Size(320, 50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Color(0xFF9E3840))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            change = 1;
                                            meetings = 1;
                                          });
                                          // bloc.onChildDateChange(
                                          //     _datetime + 'T00:00:00.0Z');
                                          // bloc.submitChangeEmpowermentMeetingExecutionDate();
                                        },
                                        child: bloc.state.isLoading
                                            ? const MyLoader()
                                            : Text(
                                                "تغییر جلسه",
                                                style: TextStyle(
                                                  fontFamily: 'IRANSansXFaNum',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11,
                                                  height:
                                                      2, // This matches the 24px line height
                                                  color: Color.fromARGB(
                                                      255, 14, 14, 14),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 12.0),
                                    Center(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          minimumSize: Size(320, 50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 93, 93, 93))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 11, horizontal: 16),
                                        ),
                                        onPressed: () {
                                          bloc.cancelEmpowermentMeeting();
                                          getReservedMeeting();
                                        },
                                        child: bloc.state.isLoading
                                            ? const MyLoader()
                                            : Text(
                                                'حذف جلسه',
                                                style: TextStyle(
                                                  fontFamily: 'IRANSansXFaNum',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11,
                                                  height:
                                                      2, // This matches the 24px line height
                                                  color: Color.fromARGB(
                                                      255, 70, 70, 70),
                                                ),
                                              ),
                                      ),
                                    ),

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
                            )));
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
