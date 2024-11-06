import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactUsApp extends StatelessWidget {
  const ContactUsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContactUsPage();
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'تماس با ما',
                style: TextStyle(
                  fontFamily: 'IRANSansXFaNum',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0, // Remove shadow
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ContactInfoCard(
                      imagePath: 'assets/ellipse-1201.svg',
                      iconPath:
                          'assets/huge-icon-communication-outline-calling.svg',
                      title: 'تلفن',
                      content: '0214446084',
                    ),
                    ContactInfoCard(
                      imagePath: 'assets/ellipse-1201-2.svg',
                      iconPath: 'assets/huge-icon-user-outline-users-02.svg',
                      title: 'ایمیل',
                      content: '',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'پیام شما',
                            style: TextStyle(
                              fontFamily: 'IRANSansXFaNum',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: Color(0xFF353842),
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            height: 150, // To simulate the text input area
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFF6F6F8),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'بنویسید', // Placeholder text
                                  border:
                                      OutlineInputBorder(), // Optional: to show a border like a text area
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines:
                                    null, // Makes the text field multi-line (textarea-like)
                                minLines: 5,

                                style: TextStyle(
                                  fontFamily: 'IRANSansXFaNum',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: Color(0xFF505463),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 296.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF9E3840),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'تایید و ارسال پیام',
                            style: TextStyle(
                              fontFamily: 'IRANSansXFaNum',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final String imagePath;
  final String iconPath;
  final String title;
  final String content;

  ContactInfoCard({
    required this.imagePath,
    required this.iconPath,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164.0,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            imagePath,
            width: 56.0,
            height: 56.0,
          ),
          SizedBox(height: 8),
          SvgPicture.asset(
            iconPath,
            width: 24.0,
            height: 24.0,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'IRANSansXFaNum',
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
              color: Color(0xFF696F82),
            ),
          ),
          SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'IRANSansXFaNum',
              fontWeight: FontWeight.w600,
              fontSize: 12.0,
              color: Color(0xFF353842),
            ),
          ),
        ],
      ),
    );
  }
}
