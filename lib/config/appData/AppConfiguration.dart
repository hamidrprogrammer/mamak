import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConfiguration {
  static const versionCode = 38;
  static const versionName = '6.19.5';
  static const packageName = 'ir.mamakschool.mamak';

  static bool enableNetworkLog = false;
  static bool cafeBazaar = true;
  static bool multiLanguage = true;
  static Locale? forceLocale = multiLanguage ? null : const Locale('fa', 'IR');

  get extraHeaders => {
        'version': versionCode.toString(),
        'platform': kIsWeb ? 'WebApp' : 'Android',
        if (!kIsWeb)
          'UserCheck':
              'encJw5GsbnGYNXmKtu5PiUOFPYeMX8sMDpfaZ31ksdq1KR5YtyfrvoaizJYfe866'
      };
}